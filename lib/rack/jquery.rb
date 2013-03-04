require "rack/jquery/version"

module Rack

  # jQuery CDN script tags and fallback in one neat package.
  class JQuery

    JQUERY_FALLBACK_FILE = "jquery-#{VERSION}.min.js"

    # Script tags for the Media Temple CDN
    MEDIA_TEMPLE = "<script src='http://code.jquery.com/#{JQUERY_FALLBACK_FILE}'></script>"

    # Script tags for the Google CDN
    GOOGLE = "<script src='//ajax.googleapis.com/ajax/libs/jquery/#{VERSION}/jquery.min.js'></script>"

    # Script tags for the Microsoft CDN
    MICROSOFT = "<script src='http://ajax.aspnetcdn.com/ajax/jQuery/#{JQUERY_FALLBACK_FILE}'></script>"

    # This javascript checks if the jQuery object has loaded. If not, that most likely means the CDN is unreachable, so it uses the local minified jQuery.
    FALLBACK = <<STR
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
      document.write(unescape("%3Cscript src='/js/#{JQUERY_FALLBACK_FILE}' type='text/javascript'%3E))
  };
</script>
STR

    # HTTP date format.
    # @see http://www.ietf.org/rfc/rfc1123.txt
    HTTP_DATE = "%a, %d %b %Y %T GMT"

    # Ten years in seconds.
    TEN_YEARS  = 60 * 60 * 24 * 365 * 10

    # @param [Symbol] organisation Choose which CDN to use, either :google, :microsoft or :media_temple
    # @return [String] The HTML script tags to get the CDN.
    def self.cdn( organisation=:google  )
      script = case organisation
        when :media_temple
          MEDIA_TEMPLE
        when :microsoft
          MICROSOFT
        else
          GOOGLE
      end
      "#{script}\n#{FALLBACK}"
    end


    # Default options hash for the middleware.
    DEFAULT_OPTIONS = {
      :http_path => "/js"
    }


    # @param [#call] app
    # @param [Hash] options
    # @option options [String] :http_path If you wish the jQuery fallback route to be "/js/jquery-1.9.1.min.js" (or whichever version this is at) then do nothing, that's the default. If you want the path to be "/assets/javascripts/jquery-1.9.1.min.js" then pass in `:http_path => "/assets/javascripts".
    # @example
    #   # The default:
    #   use Rack::JQuery
    #   # With a different route to the fallback:
    #   use Rack::JQuery, :http_path => "/assets/js"
    def initialize( app, options={} )
      @app, @options  = app, DEFAULT_OPTIONS.merge(options)
      @http_path_to_jquery = ::File.join @options[:http_path], JQUERY_FALLBACK_FILE
    end


    # @param [Hash] env Rack request environment hash.
    def call( env )
      request = Rack::Request.new(env.dup)
      if request.path_info == @http_path_to_jquery
        response = Rack::Response.new
        # for caching
        response.headers.merge!( {
          "Last-Modified" => JQUERY_VERSION_DATE,
          "Expires"    => (Time.now + TEN_YEARS).strftime(HTTP_DATE),
          "Cache-Control" => "max-age=#{TEN_YEARS},public",
          "Etag"          => "#{JQUERY_FALLBACK_FILE}",
          'Content-Type' =>'application/javascript; charset=utf-8'
        })

        # There's no need to test if the IF_MODIFIED_SINCE against the release date because the header will only be passed if the file was previously accessed by the requester, and the file is never updated. If it is updated then it is accessed by a different path.
        if request.env['HTTP_IF_MODIFIED_SINCE']
          response.status = 304
        else
          response.status = 200
          response.write ::File.read( ::File.expand_path "../../../vendor/assets/javascripts/#{JQUERY_FALLBACK_FILE}", __FILE__)
        end
        response.finish
      else
        @app.call(env)
      end
    end # call

  end
end
