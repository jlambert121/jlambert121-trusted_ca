require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

require 'simplecov'
require 'simplecov-console'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::Console
  ])
end

# Commented so travis is happy with ruby 1.8.7
#RSpec.configure do |config|
#    config.filter_run focus: true
#    config.run_all_when_everything_filtered = true
#end

RSpec.configure do |c|
  c.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
end
