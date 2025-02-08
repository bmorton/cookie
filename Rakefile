# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"
require "steep/cli"

desc "Run type checks"
task :steep do
  sh "steep check"
end

task default: %i[standard steep spec]
