module Rack
  class JQuery
    VERSION = "1.0.3"
    JQUERY_VERSION = "1.9.1"

    # This is the release date of the jQuery file, it makes an easy "Last-Modified" date for setting the headers around caching.
    # @todo remember to change Last-Modified with each release!
    JQUERY_VERSION_DATE = "Mon, 04 Feb 2013 00:00:00 GMT"
  end
end
