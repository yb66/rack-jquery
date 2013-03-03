# encoding: UTF-8

config_path = File.expand_path '../../../examples/config.rb', File.dirname(__FILE__)
require_relative config_path

shared_context "All routes" do
  include Rack::Test::Methods
  let(:app){ App }
end

shared_examples_for "Any route" do
  subject { last_response }
  it { should be_ok }
end