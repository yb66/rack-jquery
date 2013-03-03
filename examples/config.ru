require "rubygems"
require "bundler"
Bundler.setup(:examples)
require File.expand_path( '../config.rb', __FILE__)


# app = Rack::Builder.app do
#   use Rack::JQuery
  run App
# end
# 
# run app