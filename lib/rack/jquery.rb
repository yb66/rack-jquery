require "rack/jquery/version"
require "rack/jquery/helpers"

# @see http://rack.github.io/
module Rack

  # jQuery CDN script tags and fallback in one neat package.
  class JQuery
    include Helpers

    # Current file name of fallback.
    JQUERY_FILE_NAME = "jquery-#{JQUERY_VERSION}.min.js"

    # Fallback source map file name.
    JQUERY_SOURCE_MAP = "jquery-#{JQUERY_VERSION}.min.map"


    # Namespaced CDNs for convenience.
    module CDN

      # Script tags for the Media Temple CDN
      MEDIA_TEMPLE = "http://code.jquery.com/#{JQUERY_FILE_NAME}"

      # Script tags for the Google CDN
      GOOGLE = "//ajax.googleapis.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"

      # Script tags for the Microsoft CDN
      MICROSOFT = "//ajax.aspnetcdn.com/ajax/jQuery/#{JQUERY_FILE_NAME}"

      # Script tags for the Cloudflare CDN
      CLOUDFLARE = "//cdnjs.cloudflare.com/ajax/libs/jquery/#{JQUERY_VERSION}/jquery.min.js"

    end

    # This javascript checks if the jQuery object has loaded. If not, that most likely means the CDN is unreachable, so it uses the local minified jQuery.
    FALLBACK = <<STR
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
    document.write(unescape("%3Cscript src='/js/#{JQUERY_FILE_NAME}' type='text/javascript'%3E%3C/script%3E"))
  };
</script>
STR

    # @param [Hash] env The rack env hash.
    # @param [Symbol] organisation Choose which CDN to use, either :google, :microsoft or :media_temple, or :cloudflare. This will override anything set via the `use` statement.
    # @return [String] The HTML script tags to get the CDN.
    def self.cdn( env, options={}  )
      if env.nil? || env.has_key?(:organisation)
        fail ArgumentError, "The Rack::JQuery.cdn method needs the Rack environment passed to it, or at the very least, an empty hash."
      end

      organisation =  options[:organisation] ||
                        env["rack.jquery.organisation"] ||
                        :media_temple

      script = case organisation
        when :media_temple
          CDN::MEDIA_TEMPLE
        when :microsoft
          CDN::MICROSOFT
        when :cloudflare
          CDN::CLOUDFLARE
        when :google
          CDN::GOOGLE
        else
          CDN::MEDIA_TEMPLE
      end
      "<script src='#{script}'></script>\n#{FALLBACK}"
    end


    # Default options hash for the middleware.
    DEFAULT_OPTIONS = {
      :http_path => "/js"
    }


    # @param [#call] app
    # @param [Hash] options
    # @option options [String] :http_path If you wish the jQuery fallback route to be "/js/jquery-1.9.1.min.js" (or whichever version this is at) then do nothing, that's the default. If you want the path to be "/assets/javascripts/jquery-1.9.1.min.js" then pass in `:http_path => "/assets/javascripts".
    # @option options [Symbol] :organisation see {Rack::JQuery.cdn}
    # @example
    #   # The default:
    #   use Rack::JQuery
    #
    #   # With a different route to the fallback:
    #   use Rack::JQuery, :http_path => "/assets/js"
    #
    #   # With a default organisation:
    #   use Rack::JQuery, :organisation => :cloudflare
    def initialize( app, options={} )
      @app, @options  = app, DEFAULT_OPTIONS.merge(options)
      @http_path_to_jquery = ::File.join @options[:http_path], JQUERY_FILE_NAME
      @http_path_to_source_map = ::File.join @options[:http_path], JQUERY_SOURCE_MAP
      @organisation = options.fetch :organisation, :media_temple
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
      if request.path_info == @http_path_to_jquery
        response = Rack::Response.new
        # for caching
        response.headers.merge! caching_headers( JQUERY_FILE_NAME, JQUERY_VERSION_DATE)

        # There's no need to test if the IF_MODIFIED_SINCE against the release date because the header will only be passed if the file was previously accessed by the requester, and the file is never updated. If it is updated then it is accessed by a different path.
        if request.env['HTTP_IF_MODIFIED_SINCE']
          response.status = 304
        else
          response.status = 200
          response.write ::File.read( ::File.expand_path "../../../vendor/assets/javascripts/#{JQUERY_FILE_NAME}", __FILE__)
        end
        response.finish
      elsif request.path_info == @http_path_to_source_map
        response = Rack::Response.new
        # No need for caching with the source map
        response.status = 200
        response.write ::File.read( ::File.expand_path "../../../vendor/assets/javascripts/#{JQUERY_SOURCE_MAP}", __FILE__)
        response.finish
      else
        @app.call(env)
      end
    end # call

  end
end
