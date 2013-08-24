require 'bundler/setup'
require 'padrino-core/cli/rake'
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'test'  unless defined?(PADRINO_ENV)

PadrinoTasks.use(:database)
PadrinoTasks.use(:datamapper)
PadrinoTasks.init

puts "PADRINO_ENV: #{PADRINO_ENV}"
if ['development', 'test', 'travis'].include?(PADRINO_ENV)
	require 'cucumber/rake/task'

	task :travis do
  ["rake spec", "rake cucumber"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
    end
  end

	Cucumber::Rake::Task.new(:cucumber) do |task|
  	Rake::Task['db:migrate'].invoke
  	task.cucumber_opts = ["features"]
	end

	task :default => [:travis]
end
