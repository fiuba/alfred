require 'bundler/setup'
require 'padrino-core/cli/rake'
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'test'  unless defined?(PADRINO_ENV)

task :version do
  require './lib/version.rb'
  puts Version.current
  exit 0
end

PadrinoTasks.use(:database)
PadrinoTasks.use(:datamapper)
PadrinoTasks.init

if ['development', 'test', 'travis'].include?(PADRINO_ENV)
  puts "PADRINO_ENV: #{PADRINO_ENV}"
	require 'cucumber/rake/task'

	task :travis do
  ["rake spec", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end

  task :jenkins do
  ["rake spec_report", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end

  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec_report) do |t|
    t.pattern = "./spec/**/*_spec.rb"
    t.rspec_opts = %w(--format RspecJunitFormatter --out reports/spec/spec.xml)
  end

	Cucumber::Rake::Task.new(:cucumber) do |task|
  	Rake::Task['db:migrate'].invoke
  	task.cucumber_opts = ["features"]
	end

	task :default => [:travis]
end
