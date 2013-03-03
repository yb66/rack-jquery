require "rack/jquery/version"

module Rack
  class JQuery

    MEDIA_TEMPLE = "<script src='http://code.jquery.com/jquery-#{VERSION}.min.js'></script>"
    GOOGLE = "<script src='//ajax.googleapis.com/ajax/libs/jquery/#{VERSION}/jquery.min.js'></script>"
    MICROSOFT = "<script src='http://ajax.aspnetcdn.com/ajax/jQuery/jquery-#{VERSION}.min.js'></script>"

    FALLBACK = <<STR
<script type="text/javascript">
  if (typeof jQuery == 'undefined') {
      document.write(unescape("%3Cscript src='/js/jquery-#{VERSION}.min.js' type='text/javascript'%3E))
  };
</script>
STR

    HTTP_DATE = '%a, %d %b %Y %T GMT'

    ONE_YEAR  = 60 * 60 * 24 * 365

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


    def initialize( app, options={} )
      @app, @options  = app, options
    end

    def call( env )
      status, headers, body = @app.call(env)
      if env['PATH_INFO'] == "/js/jquery-#{VERSION}.min.js"
        headers['Content-Type']   = 'application/javascript'
        headers["Last-Modified"]  = JQUERY_VERSION_DATE
        headers["Expires"] = (Time.now + ONE_YEAR).strftime HTTP_DATE
        headers["Cache-Control"]  = "max-age=#{ONE_YEAR},public"
        headers["Etag"]           = "jquery-#{VERSION}.min.js"
        # TODO caching
        body = ::File.read( ::File.expand_path "../../../vendor/assets/javascripts/jquery-#{VERSION}.min.js", __FILE__)
        headers['Content-Length'] = Rack::Utils.bytesize( body ).to_s

        # There's no need to test if the IF_MODIFIED_SINCE against the release date because the header will only be passed if the file was previously accessed by the requester, and the file is never updated. If it is updated then it is accessed by a different path.
        if env['HTTP_IF_MODIFIED_SINCE']
          status = 304
          body = []
        else
          status = 200
          body = [body]
        end
      end
      
      [status,headers,body]
    end # call

  end
end
