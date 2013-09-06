# encoding: UTF-8

require 'spec_helper'
require_relative "../lib/rack/jquery.rb"

describe "The class methods" do
  subject { Rack::JQuery.cdn organisation }
  context "Given an argument" do
    context "of nil (the default)" do
      let(:organisation) { nil }
      it { should == "<script src='#{Rack::JQuery::CDN::MEDIA_TEMPLE}'></script>\n#{Rack::JQuery::FALLBACK}" }
    end
    context "of :google" do
      let(:organisation) { :google }
      it { should == "<script src='#{Rack::JQuery::CDN::GOOGLE}'></script>\n#{Rack::JQuery::FALLBACK}" }
    end
    context "of :microsoft" do
      let(:organisation) { :microsoft }
      it { should == "<script src='#{Rack::JQuery::CDN::MICROSOFT}'></script>\n#{Rack::JQuery::FALLBACK}" }
    end
    context "of :media_temple" do
      let(:organisation) { :media_temple }
      it { should == "<script src='#{Rack::JQuery::CDN::MEDIA_TEMPLE}'></script>\n#{Rack::JQuery::FALLBACK}" }
    end
    context "of :cloudflare" do
      let(:organisation) { :cloudflare }
      it { should == "<script src='#{Rack::JQuery::CDN::CLOUDFLARE}'></script>\n#{Rack::JQuery::FALLBACK}" }
    end
  end
end

describe "Inserting the CDN" do
  include_context "All routes"
  context "Check the examples run at all" do
    before do
      get "/"
    end
    it_should_behave_like "Any route"
  end
  context "Google CDN" do
    before do
      get "/google-cdn"
    end
    it_should_behave_like "Any route"
    subject { last_response.body }
    let(:expected) { Rack::JQuery::CDN::GOOGLE }
    it { should include expected }
  end
  context "Microsoft CDN" do
    before do
      get "/microsoft-cdn"
    end
    it_should_behave_like "Any route"
    subject { last_response.body }
    let(:expected) { Rack::JQuery::CDN::MICROSOFT }
    it { should include expected }
  end
  context "Media_temple CDN" do
    before do
      get "/media-temple-cdn"
    end
    it_should_behave_like "Any route"
    subject { last_response.body }
    let(:expected) { Rack::JQuery::CDN::MEDIA_TEMPLE }
    it { should include expected }
  end
  context "Unspecified CDN" do
    before do
      get "/unspecified-cdn"
    end
    it_should_behave_like "Any route"
    subject { last_response.body }
    let(:expected) { Rack::JQuery::CDN::MEDIA_TEMPLE }
    it { should include expected }
  end
  context "Cloudflare CDN" do
    before do
      get "/cloudflare-cdn"
    end
    it_should_behave_like "Any route"
    subject { last_response.body }
    let(:expected) { Rack::JQuery::CDN::CLOUDFLARE }
    it { should include expected }
  end
end


require 'timecop'
require 'time'

describe "Serving the fallback jquery" do
  include_context "All routes"
  before do
    get "/js/jquery-#{Rack::JQuery::JQUERY_VERSION}.min.js"
  end
  it_should_behave_like "Any route"
  subject { last_response.body }
  it { should start_with "/*! jQuery v#{Rack::JQuery::JQUERY_VERSION}" }

  context "Re requests" do
    before do
      at_start = Time.parse(Rack::JQuery::JQUERY_VERSION_DATE) + 60 * 60 * 24 * 180
      Timecop.freeze at_start
      get "/js/jquery-#{Rack::JQuery::JQUERY_VERSION}.min.js"
      Timecop.travel Time.now + 86400 # add a day
      get "/js/jquery-#{Rack::JQuery::JQUERY_VERSION}.min.js", {}, {"HTTP_IF_MODIFIED_SINCE" => Rack::Utils.rfc2109(at_start) }
    end
    subject { last_response }
    its(:status) { should == 304 }
    
  end
end