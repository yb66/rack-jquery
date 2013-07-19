# CH CH CH CHANGES #

## Friday the 19th of July 2013 ##

### v1.5.0 ###

* Updated jQuery to v2.0.3.
* Updated gemspec to only pull in the correct vendored version of jQuery from the repo.
* Last modified date on the file is now using the correct format, RFC 2822, not RFC 2109's as before.
* Added in a check that the CDNs support the version being pushed out, for my sanity. Slight reorganisation of the code to help with this.

----


### v1.4.0 ###

* Made Media Temple the default CDN, since Google and Microsoft (and others) are now in the employ of Lucifer and his minions running the states of the UK and US, I don't feel like helping them track people round the web in any way, and certainly not making it easier for them by default.

----


## v1.3.2 ##

Thursday the 23rd of May 2013

* Made the Microsoft CDN link protocol relative.

----


## v1.3.1 ##

Thursday the 23rd of May 2013

* Added an easier way to run the examples.
* Added links to make it easier to move around the app.

----


## v1.3.0 ##

Thursday the 23rd of May 2013

* Added the Cloudflare CDN.

____


## v1.2.0 ##

Thursday the 23rd of May 2013

* Added notes about the version number.
* Updated the jQuery release for v2.0.0. See http://blog.jquery.com/2013/04/18/jquery-2-0-released/.

----


## v1.1.0 ##

Friday the 22nd of March 2013

* Improved README by adding how to use the middleware (and why).
* Should be thread safe now, by duplicating the `call` method.

----

## v1.0.4 ##

Friday the 8th of March 2013

* The jQuery version will now show up automatically in the description.

----

## v1.0.3 ##

Friday the 8th of March 2013

* Using shared rack-jquery-helpers library to cut down on duplication.

----

## v1.0.2 ##

Tuesday the 5th of March 2013

* Date format is produced by Rack::Utils now.
* Included the jQuery libary (my .gitignore worked against me there, whoops!) and the licence for it.

## v1.0.1 ##

Tuesday the 5th of March 2013

* Script tags for the fallback script weren't properly formed, fixed.
* Added a bit of simple jquery to the examples to show to anyone running them that jQuery has indeed loaded.

----

## v1.0.0 ##

Monday the 4th of March 2013

* Version bumped to 1.0.0 to mark the public interface as stable (see [semver](http://semver.org/) for more info).

----
