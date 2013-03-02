require "rack/jquery/version"

module Rack
  class JQuery

    MEDIA_TEMPLE = '<script src="http://code.jquery.com/jquery-#{VERSION}.min.js"></script>'
    GOOGLE = '<script src="//ajax.googleapis.com/ajax/libs/jquery/#{VERSION}/jquery.min.js"></script>'
    MICROSOFT = '<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-#{VERSION}.min.js"></script>'

    FALLBACK = <<STR
if (typeof jQuery == 'undefined') {
    document.write(
      unescape(
        "%3Cscript src='/js/jquery-#{VERSION}.min.js' type='text/javascript'%3E
      )
    )
  };
STR

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
      script
    end


    def initialize( app, options={} )
      @app, @options  = app, options
    end

    def call( env )
      status, headers, body = @app.call(env)
      body = if env['PATH_INFO'] == "/js/jquery-#{VERSION}.js"
        # TODO caching
        body = File.read( File.expand_path "../../vendor/assets/javascripts/jquery-#{VERSION}.min.js", File.dirname(__FILE__) )
        headers['Content-Length'] = body.length.to_s
        headers['Content-Type']   = 'application/javascript'
        body
      end
      
      [status,headers,body]
    end # call

  end
end
