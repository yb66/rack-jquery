require 'sinatra/base'
require 'haml'
require 'rack/jquery'

class App < Sinatra::Base

  enable :inline_templates
  use Rack::JQuery

  get "/" do
    "RUNNING"
  end

  get "/google-cdn" do
    haml :index, :layout => :google
  end

  get "/media-temple-cdn" do
    haml :index, :layout => :mediatemple
  end

  get "/microsoft-cdn" do
    haml :index, :layout => :microsoft
  end

  get "/unspecified-cdn" do
    haml :index, :layout => :unspecified
  end
end

__END__

@@google
%html
  %head
    = Rack::JQuery.cdn( :google )
  = yield

@@microsoft
%html
  %head
    = Rack::JQuery.cdn( :microsoft )
  = yield

@@mediatemple
%html
  %head
    = Rack::JQuery.cdn( :media_temple )
  = yield

@@unspecified
%html
  %head
    = Rack::JQuery.cdn()
  = yield

@@index
%p
  "NOTHING TO SEE HERE, MOVE ALONG, MOVE ALONG"