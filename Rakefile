require 'rake'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'foodcritic'
require 'rspec/core/rake_task'

desc 'Run all tests'
task test: [
  :rubocop,
  :foodcritic,
  :unit
]

task default: [:test]

desc 'Lists all the tasks.'
task :list do
  puts "Tasks: \n- #{Rake::Task.tasks.join("\n- ")}"
end

RuboCop::RakeTask.new(:rubocop)

FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = {
    fail_tags: ['any']
  }
end

RSpec::Core::RakeTask.new(:unit) do |t|
  t.rspec_opts = [].tap do |a|
    a.push('--color')
    a.push('--format progress')
  end.join(' ')
end
