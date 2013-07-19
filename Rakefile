require "bundler/gem_tasks"


desc "(Re-) generate documentation and place it in the docs/ dir. Open the index.html file in there to read it."
task :docs => [:"docs:environment", :"docs:yard"]
namespace :docs do

  task :environment do
    ENV["RACK_ENV"] = "documentation"
  end

  require 'yard'

  YARD::Rake::YardocTask.new :yard do |t|
    t.files   = ['lib/**/*.rb', 'app/*.rb', 'spec/**/*.rb']
    t.options = ['-odocs/'] # optional
  end

end

task :default => "spec"

task :spec => :"spec:run"
task :rspec => :spec
namespace :spec do
  task :environment do
    ENV["RACK_ENV"] = "test"
  end

  desc "Run specs"
  task :run, [:any_args] => :"spec:environment" do |t,args|
    warn "Entering spec task."
    any_args = args[:any_args] || ""
    cmd = "bin/rspec #{any_args}"
    warn cmd
    system cmd
  end

end

namespace :examples do

  desc "Run the examples."
  task :run do
    exec "bundle exec rackup examples/config.ru"
  end

end


namespace :cdn do
  require 'open3'
  desc "An availability check, for sanity"
  task :check do
    require_relative './lib/rack/jquery.rb'
    Rack::JQuery::CDN.constants.each do |const|
      url = "#{Rack::JQuery::CDN.const_get(const)}"
      url = "http:#{url}" unless url.start_with? "http"
      cmd = "curl -I #{url}"
      puts cmd
      puts catch(:status) {
        Open3.popen3(cmd) do |_,stdout,_|
          line = stdout.gets
          throw :status, "Nothing for #{const}" if line.nil?
          puts line.match("HTTP/1.1 404 Not Found") ?
              "FAILED: #{const}" :
              "PASSED: #{const}"
        end
      }
    end
  end

end