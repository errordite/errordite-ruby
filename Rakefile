require 'bundler/gem_helper'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

gems = ['errordite', 'errordite-rack', 'errordite-rails']
gems.each do |gem|
  namespace gem do
    Bundler::GemHelper.install_tasks name: gem
  end
end

desc 'build all gems'
task build: gems.map {|g| "#{g}:build"}
desc 'install all gems'
task install: gems.map {|g| "#{g}:install"}
desc 'release all gems'
task release: gems.map {|g| "#{g}:release"}

task :default => :spec
