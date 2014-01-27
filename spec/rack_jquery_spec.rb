# encoding: UTF-8

require 'spec_helper'
require_relative "../lib/rack/jquery.rb"

describe "The class methods" do

  context "#raiser?" do
    subject { Rack::JQuery.raiser? env, options }
    context "Given an option to raise" do
      context "Set to true" do
        let(:options) { {:raise => true} }

        context "Given an empty env" do
          let(:env) { {} }
          it { should be_true }
        end
        context "Given an env with rack.jquery.raise" do
          context "Set to true" do
            let(:env) { {"rack.jquery.raise" => true} }
            it { should be_true }
          end
          context "Set to false" do
            let(:env) { {"rack.jquery.raise" => false} }
            it { should be_true }
          end
        end
      end
      context "Set to false" do
        let(:options) { {:raise => false} }

        context "Given an empty env" do
          let(:env) { {} }
          it { should be_false }
        end
        context "Given an env with rack.jquery.raise" do
          context "Set to true" do
            let(:env) { {"rack.jquery.raise" => true} }
            it { should be_false }
          end
          context "Set to false" do
            let(:env) { {"rack.jquery.raise" => false} }
            it { should be_false }
          end
        end

        context "and given empty options" do
          let(:options) { {} }
          context "Given an env with rack.jquery.raise" do
            context "Set to true" do
              let(:env) { {"rack.jquery.raise" => true} }
              it { should be_true }
            end
            context "Set to false" do
              let(:env) { {"rack.jquery.raise" => false} }
              it { should be_false }
            end
          end
        end
      end
    end
  end


  context "#cdn" do
    let(:env) { {} }
    subject { Rack::JQuery.cdn env, :organisation => organisation }

    context "Given the organisation option" do
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

    context "Given no Rack env argument" do
      it "should fail and give a message" do
        expect{ Rack::JQuery.cdn nil }.to raise_error(ArgumentError)
      end

      context "and an organisation option" do
        it "should fail and give a message" do
          expect{ Rack::JQuery.cdn nil, {:organisation => :microsoft} }.to raise_error(ArgumentError)
        end
      end
    end
  end
end

describe "Inserting the CDN" do

  # These check the default is overriden
  # when `cdn` is given a value
  # but when not, the default is used.
  context "When given a default" do
    include_context "All routes" do
      let(:app){ AppWithDefaults }
    end
    context "Check the examples run at all" do
      before do
        get "/"
      end
      it_should_behave_like "Any route"
    end
    context "Google CDN" do
      context "With :raise set to false (the default)" do
        let(:expected) { Rack::JQuery::CDN::GOOGLE }
        before do
          get "/google-cdn"
        end
        it_should_behave_like "Any route"
        subject { last_response.body }
        it { should include expected }
      end
      context "With :raise set to true" do
        context "via `use`" do
          let(:app) {
            Sinatra.new do
              use Rack::JQuery, :raise => true
              get "/google-cdn" do
                Rack::JQuery.cdn( env, :organisation => :google )
              end
            end
          }
          it "should raise error as it's not supported for this version" do
            expect { get "/google-cdn" }.to raise_error
          end
#           it { should include expected }
        end
        context "via the method options" do
          let(:app) {
            Sinatra.new do
              use Rack::JQuery, :raise => false
              get "/google-cdn" do
                Rack::JQuery.cdn( env, :organisation => :google, :raise => true )
              end
            end
          }
          subject { get "/google-cdn" }
          it "should raise error as it's not supported for this version" do
            expect { subject }.to raise_error
          end
#           it { should include expected }
        end
      end
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
      let(:expected) { Rack::JQuery::CDN::CLOUDFLARE }
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
  context "When not given a default" do
    include_context "All routes"
    context "Check the examples run at all" do
      before do
        get "/"
      end
      it_should_behave_like "Any route"
    end
    context "Google CDN" do
      it "Should fail" do
        expect { get "/google-cdn" }.to raise_error
      end
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
