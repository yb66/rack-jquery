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
