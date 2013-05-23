module Rack
  class JQuery
    VERSION = "1.2.0" # the version of this library
    JQUERY_VERSION = "2.0.0" # the version of jQuery it supports.

    # This is the release date of the jQuery file, it makes an easy "Last-Modified" date for setting the headers around caching.
    # @todo remember to change Last-Modified with each release!
    JQUERY_VERSION_DATE = "Thu, 18 Apr 2013 00:00:00 GMT"
  end
end
