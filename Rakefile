require 'rubygems'
require 'bundler/setup'
require 'bundler/gem_tasks'
require 'yard'
require 'rspec/core/rake_task'

$stdout.sync = true
$stderr.sync = true

# Change to the directory of this file
Dir.chdir(File.expand_path("../", __FILE__))

# Tasks to help with gem creation and publishing
Bundler::GemHelper.install_tasks

# Test tasks with RSpec
RSpec::Core::RakeTask.new

# Documentation tasks
YARD::Rake::YardocTask.new do |t|
  t.files = ['lib/**/*.rb']
end

# Build the ctags fo vim
desc "Builds the tags"
task :ctags do
  %x[ git ls-files | ctags --tag-relative --sort=no  --exclude=.idea -L - -f ".git/tags" ]
end

# By default we test the gem
task :default => 'spec'
