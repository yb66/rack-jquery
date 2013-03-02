
require 'sinatra/base'

class App < Sinatra::Base

  use Rack::JQuery

  get "/google-cdn" do
    haml :index, :layout => :google
  end

  get "/media-temple-cdn" do
    haml :index, :layout => :mediatemple
  end

  get "/microsft-cdn" do
    haml :index, :layout => :microsoft
  end

  get "/unspecified-cdn" do
    haml :index, :layout => :unspecified
  end


end

run App

__END__

@@google
%html
  %head
    = Rack::JQuery.cdn( :google )
  = yield

@@microsoft
%html
  %head
    = Rack::JQuery.cdn( :google )
  = yield

@@mediatemple
%html
  %head
    = Rack::JQuery.cdn( :google )
  = yield

@@unspecified
%html
  %head
    = Rack::JQuery.cdn()
  = yield

@@index
  %p
    "NOTHING TO SEE HERE, MOVE ALONG, MOVE ALONG"