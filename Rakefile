# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

GnipHistoricalManagerator::Application.load_tasks

task default: :spec
task test: [:spec, 'spec:javascript']

migration_task = task 'db:migrate'
migration_task.clear_actions
task 'db:migrate' do
   $stderr.puts 'Not running migrations.. This Application does not talk to a Database.'
end
