source 'https://rubygems.org'
RUBY_ENGINE = 'ruby' unless defined? RUBY_ENGINE

# Specify your gem's dependencies in rack-jquery.gemspec
gemspec

group :test do
  gem 'rspec'
  gem 'simplecov'
  gem 'rack-test'
  gem "timecop"
end

group :examples do
  gem "sinatra"
  gem "haml"
end

group :development do
  unless RUBY_ENGINE == 'jruby' || RUBY_ENGINE == "rbx"
    gem "pry"
    gem "pry-byebug"
  end
  gem "yard"
  gem "maruku"
end
