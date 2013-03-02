# encoding: UTF-8

require 'spec_helper'
require_relative "../lib/rack/jquery.rb"

describe "The class methods" do
  subject { Rack::JQuery.cdn organisation }
  context "Given an argument" do
    context "of nil (the default)" do
      let(:organisation) { nil }
      it { should == Rack::JQuery::GOOGLE }
    end
    context "of :google" do
      let(:organisation) { :google }
      it { should == Rack::JQuery::GOOGLE }
    end
    context "of :microsoft" do
      let(:organisation) { :microsoft }
      it { should == Rack::JQuery::MICROSOFT }
    end
    context "of :media_temple" do
      let(:organisation) { :media_temple }
      it { should == Rack::JQuery::MEDIA_TEMPLE }
    end
  end
end

# describe "Inserting the CDN" do
#   before do
#     get "/"
#   end
#   let(:expected) { Rack::JQuery::GOOGLE }
#   it { should include expected }
# 
# end