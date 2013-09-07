require "rubygems"
require "bundler"
Bundler.setup(:examples)
require File.expand_path( '../config.rb', __FILE__)


map "/defaults" do
  run AppWithDefaults
end

run App
