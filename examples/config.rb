require 'sinatra/base'
require 'haml'
require 'rack/jquery'

class App < Sinatra::Base

  enable :inline_templates
  use Rack::JQuery, :raise => true

  get "/" do
    output = <<STR
!!!
%body
  %ul
    %li
      %a{ href: "/google-cdn"} google-cdn
    %li
      %a{ href: "/media-temple-cdn"} media-temple-cdn
    %li
      %a{ href: "/microsoft-cdn"} microsoft-cdn
    %li
      %a{ href: "/cloudflare-cdn"} cloudflare-cdn
    %li
      %a{ href: "/unspecified-cdn"} unspecified-cdn
STR
    haml output
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

  get "/cloudflare-cdn" do
    haml :index, :layout => :cloudflare
  end

  get "/unspecified-cdn" do
    haml :index, :layout => :unspecified
  end
end


class AppWithDefaults < Sinatra::Base

  enable :inline_templates
  use Rack::JQuery, :organisation => :cloudflare

  get "/" do
    output = <<STR
!!!
%body
  %ul
    %li
      %a{ href: "/google-cdn"} google-cdn
    %li
      %a{ href: "/media-temple-cdn"} media-temple-cdn
    %li
      %a{ href: "/microsoft-cdn"} microsoft-cdn
    %li
      %a{ href: "/cloudflare-cdn"} cloudflare-cdn
    %li
      %a{ href: "/unspecified-cdn"} unspecified-cdn
STR
    haml output
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

  get "/cloudflare-cdn" do
    haml :index, :layout => :cloudflare
  end

  get "/unspecified-cdn" do
    haml :index, :layout => :unspecified
  end
end

__END__

@@google
%html
  %head
    = Rack::JQuery.cdn(env, :organisation => :google )
  = yield

@@microsoft
%html
  %head
    = Rack::JQuery.cdn( env, :organisation => :microsoft )
  = yield

@@mediatemple
%html
  %head
    = Rack::JQuery.cdn( env, :organisation => :media_temple )
  = yield

@@cloudflare
%html
  %head
    = Rack::JQuery.cdn( env, :organisation => :cloudflare )
  = yield

@@unspecified
%html
  %head
    = Rack::JQuery.cdn(env)
  = yield

@@index
  
%p.aclass
  "NOTHING TO SEE HERE… "
%p.aclass
  "MOVE ALONG… "
%p.aclass
  "MOVE ALONG… "
#placeholder
:javascript
  all_text = $('.aclass').text();
  $('#placeholder').text(all_text).mouseover(function() {
    $(this).css({ 'color': 'red', 'font-size': '150%' });    
  }).mouseout(function() {
    $(this).css({ 'color': 'blue', 'font-size': '100%' });
  });
