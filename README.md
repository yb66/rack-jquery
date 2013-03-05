# Rack::JQuery

[jQuery](http://jquery.com/download/) CDN script tags and fallback in one neat package.

### Build status ###

Master branch:
[![Build Status](https://secure.travis-ci.org/yb66/rack-jquery.png?branch=master)](http://travis-ci.org/yb66/rack-jquery)

## Why? ##

I get tired of copy and pasting and downloading and moving… jQuery files and script tags etc. This does it for me, and keeps version management nice 'n' easy.

## Usage ##

Have a look in the examples directory, but here's a snippet.

* Install it (see below)
* `require 'rack/jquery'`.
* Put this in the head of your layout (the example is Haml but you can use whatever you like)

    <pre><code>
    %head
      = Rack::JQuery.cdn
    </code></pre>

Now you have the script tags to Google's CDN in the head (you can also use Media Temple or Microsoft, see the docs).

It also adds in a bit of javascript that will load in a locally kept version of jQuery, just incase the CDN is unreachable. The script will use the "/js/jquery-1.9.1.min.js" path (or, instead of 1.9.1, whatever is in {Rack::JQuery::VERSION}). You can change the "/js" bit if you like (see the docs).

That was easy.

## Version numbers ##

This library uses [semver](http://semver.org/) to version the **library**. That means the library version is ***not*** an indicator of quality but a way to manage changes. The version of jQuery can be found in the lib/rack/jquery/version.rb file, or via the {Rack::JQuery::JQUERY_VERSION} constant.

## Installation

Add this line to your application's Gemfile:

    gem 'rack-jquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-jquery

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Licences ##

The licence for this library is contained in LICENCE.txt. The jQuery library licence is contained in JQUERY-LICENCE.txt.
