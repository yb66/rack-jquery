# Rack::JQuery

[jQuery](http://jquery.com/download/) CDN script tags and fallback in one neat package.

### Build status ###

Master branch:
[![Build Status](https://secure.travis-ci.org/yb66/rack-jquery.png?branch=master)](http://travis-ci.org/yb66/rack-jquery)

### Why? ###

I get tired of copy and pasting and downloading and moving… jQuery files and script tags etc. This does it for me, and keeps version management nice 'n' easy.

### Usage ###

Have a look in the examples directory, but here's a snippet.

* Install it (see below)
* `require 'rack/jquery'`.
* If you want fallback then add this to your middleware stack: `use Rack::JQuery`
* Put this in the head of your layout (the example is Haml but you can use whatever you like)

    <pre><code>
    %head
      = Rack::JQuery.cdn
    </code></pre>

Now you have the script tags to Google's CDN in the head (you can also use Media Temple or Microsoft, or Cloudflare, see the docs).

It also adds in a bit of javascript that will load in a locally kept version of jQuery, just incase the CDN is unreachable. The script will use the "/js/jquery-1.9.1.min.js" path (or, instead of 1.9.1, whatever is in {Rack::JQuery::VERSION}). You can change the "/js" bit if you like (see the docs).

That was easy.

### Version numbers ###

This library uses [semver](http://semver.org/) to version the **library**. That means the library version is ***not*** an indicator of quality but a way to manage changes. The version of jQuery can be found in the lib/rack/jquery/version.rb file, or via the {Rack::JQuery::JQUERY_VERSION} constant.

On top of that, version numbers will also change when new releases of jQuery are supported.

* If jQuery makes a major version jump, then this library will make a ***minor*** jump. That is because the API for the library has not really changed, but it is *possibly* a change that will break things.
* If jQuery makes a minor version jump, then so will this library, for the same reason as above.
* I doubt point releases will be followed, but if so, it will also precipitate a minor jump in this library's version number. That's because even though jQuery feel it's a point release, I'm not them, my responsibility is to users of this library and I'll take the cautious approach of making it a minor version number change.

As an example, if the current library version was 1.0.0 and jQuery was at 2.0.0 and I made a change that I felt was major and breaking (to the Ruby library), I'd bump Rack::JQuery's version to 2.0.0. That the version numbers match between Rack::JQuery and the jQuery script is of no significance, it's just coincidental.  
If then jQuery went to v2.1.0 and I decided to support that, I'd make the changes and bump Rack::JQuery's version to 2.1.0. That the version numbers match between Rack::JQuery and the jQuery script is of no significance, it's just coincidental.  
If then I made a minor change to the library's API that could be breaking I'd bump it to 2.2.0.  
If I then added some more instructions I'd bump Rack::JQuery's version to 2.2.1.  
If then jQuery released version 3.0.0, I'd add it to the library, and bump Rack::JQuery's version to 2.3.0.

Only one version of jQuery will be supported at a time. This is because the fallback script is shipped with the gem and I'd like to keep it as light as possible. It's also a headache to have more than one.

So basically, if you want to use a specific version of jQuery, look for the library version that supports it via the {Rack::JQuery::JQUERY_VERSION} constant. Don't rely on the version numbers of *this* library to tell you anything other than compatibility between versions of this library.

### Installation

Add this line to your application's Gemfile:

    gem 'rack-jquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-jquery

### Contributing ###

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### Licences ###

The licence for this library is contained in LICENCE.txt. The jQuery library licence is contained in JQUERY-LICENCE.txt.
