require "rack/jquery/version"
require "rack/jquery/helpers"
require 'pathname'

# @see http://rack.github.io/
module Rack

  # jQuery CDN script tags and fallback in one neat package.
  class JQuery
    include Helpers

    # Current file name of fallback.
    JQUERY_FILE_NAME = "jquery-#{JQUERY_VERSION}.min.js"
    JQUERY_SOURCE_MAP_FILE_NAME = "jquery-#{JQUERY_VERSION}.min.map"

    # Namespaced CDNs for convenience.
    module CDN

      # Script tags for the Media Temple CDN
      MEDIA_TEMPLE = "//code.jquery.com/#{JQUERY_FILE_NAME}"

      # Script tags for the Google CDN
      GOOGLE = "//ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"

      # Script tags for the Microsoft CDN
      MICROSOFT = "//ajax.aspnetcdn.com/ajax/jQuery/#{JQUERY_FILE_NAME}"

      # Script tags for the Cloudflare CDN
      CLOUDFLARE = "//cdnjs.cloudflare.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"

    end

    # path to the fallback script
    FALLBACK_PATH = "/js/#{JQUERY_FILE_NAME}"

    # This javascript checks if the jQuery object has loaded. If not, that most likely means the CDN is unreachable, so it uses the local minified jQuery.
    FALLBACK = <<STR
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='#{FALLBACK_PATH}' type='text/javascript'%3E%3C/script%3E"))
  };
</script>
STR

    # For CDN's that don't support the current release.
    WARNING = "CDN does not hold #{JQUERY_VERSION} at the time of this gem's release. Please use Rack::JQuery's Rake file by running rake cdn:check to confirm this, or choose another CDN."


    # Handles the logic for whether to raise or not
    # @note Used by the library, not for public use.
    def self.raiser?( env, options )
      (opt = options[:raise]).nil? ?
        (env["rack.jquery.raise"] || false) :
        opt
    end


    # @param [Hash] env The rack env hash.
    # @param [Hash] options
    # @option options [Symbol] :organisation Choose which CDN to use, either :google, :microsoft or :media_temple, or :cloudflare. This will override anything set via the `use` statement.
    # @return [String] The HTML script tags to get the CDN.
    # @example
    #   # in a Haml file (or any type of template)
    #   Rack::JQuery.cdn env
    #
    #   # Choose the organisation
    #   Rack::JQuery.cdn env, :organisation => :cloudflare
    #
    #   # Choose to use the fallback path instead
    #   Rack::JQuery.cdn env, :organisation => false
    #
    #   # Raise an error if the organisation doesn't
    #   # support this version of jQuery
    #   Rack::JQuery.cdn env, :raise => true
    #
    #   # Use the unminified version from the CDN
    #   Rack::JQuery.cdn env, :debug => true
    def self.cdn( env, options={}  )
      if env.nil? || env.has_key?(:organisation)
        fail ArgumentError, "The Rack::JQuery.cdn method needs the Rack environment passed to it, or at the very least, an empty hash."
      end


      organisation =  options[:organisation]
      if organisation.nil? # because false is valid
        organisation =  env["rack.jquery.organisation"].nil? ?
                          :media_temple :
                          env["rack.jquery.organisation"]
      end

      raise = raiser?( env, options )

      unless organisation == false
        script_src = 
          case organisation
            when :media_temple
              CDN::MEDIA_TEMPLE
            when :microsoft
              CDN::MICROSOFT
            when :cloudflare
              CDN::CLOUDFLARE
            when :google
#               meth = raise ? :fail : :warn
#               send meth, "#{organisation.to_s.gsub('_', ' ').capitalize}'s #{WARNING}" 
              CDN::GOOGLE
            else
              CDN::MEDIA_TEMPLE
            end
          
        debug = options.fetch :debug, false
  
        script_src = "#{script_src[0..-7]}js" if debug
        "<script src='#{script_src}'></script>\n#{FALLBACK}"
      else
        "<script src='#{FALLBACK_PATH}'></script>"
      end
    end


    # Default options hash for the middleware.
    DEFAULT_OPTIONS = {
      :http_path => "/js",
      :raise      =>  false
    }

    JQUERY_FILES_DIR = Pathname(__FILE__).join("../../../vendor/assets/javascripts")

    # @param [#call] app
    # @param [Hash] options
    # @option options [String] :http_path If you wish the jQuery fallback route to be "/js/jquery-1.9.1.min.js" (or whichever version this is at) then do nothing, that's the default. If you want the path to be "/assets/javascripts/jquery-1.9.1.min.js" then pass in `:http_path => "/assets/javascripts".
    # @option options [Symbol] :organisation see {Rack::JQuery.cdn}
    # @option options [TrueClass] :raise If one of the CDNs does not support then raise an error if it is chosen. Defaults to false.
    # @example
    #   # The default:
    #   use Rack::JQuery
    #
    #   # With a different route to the fallback:
    #   use Rack::JQuery, :http_path => "/assets/js"
    #
    #   # With a default organisation:
    #   use Rack::JQuery, :organisation => :cloudflare
    #
    #   # Raise if CDN does not support this version of the jQuery library.
    #   use Rack::JQuery, :raise => true
    #
    #   use Rack::JQuery, :source_map => :true
    def initialize( app, options={} )
      @app, @options  = app, DEFAULT_OPTIONS.merge(options)
      js_dir = Pathname(@options[:http_path])
      @http_path_to_jquery = js_dir.join JQUERY_FILE_NAME
      @raise = @options.fetch :raise, false
      @source_map = @options.fetch :source_map, false
      @http_path_to_source_map = js_dir.join JQUERY_SOURCE_MAP_FILE_NAME
      @organisation = options.fetch :organisation, :media_temple
    end


    def respond_with_local_file( source, request, date=JQUERY_VERSION_DATE )
      response = Rack::Response.new
      # for caching
      response.headers.merge! caching_headers( source, date)

      # There's no need to test if the IF_MODIFIED_SINCE against the release date because the header will only be passed if the file was previously accessed by the requester, and the file is never updated. If it is updated then it is accessed by a different path.
      if request.env['HTTP_IF_MODIFIED_SINCE']
        response.status = 304
      else
        response.status = 200
        response.write JQUERY_FILES_DIR.join(source).realpath.read
      end
      response
    end


    # @param [Hash] env Rack request environment hash.
    def call( env )
      dup._call env
    end


    # For thread safety
    # @param (see #call)
    def _call( env )
      request = Rack::Request.new(env.dup)
      env.merge! "rack.jquery.organisation" => @organisation
      env.merge! "rack.jquery.raise" => @raise
      if request.path_info == @http_path_to_jquery.to_path
        response = respond_with_local_file JQUERY_FILE_NAME, request
        response.headers.merge!("X-SourceMap" => @http_path_to_source_map.to_path) if @source_map
        response.finish
      elsif request.path_info == @http_path_to_source_map.to_path
        response = respond_with_local_file JQUERY_SOURCE_MAP_FILE_NAME, request
        response.finish
      else
        @app.call(env)
      end
    end # call

  end
end
