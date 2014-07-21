notification :off
interactor :simple

guard 'bundler' do
  watch('Gemfile')
end

guard 'coffeescript', input: 'spec/javascripts', source_map: true, all_on_start: true

guard 'rspec', all_on_start: true do
  watch('Gemfile.lock')
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)\.rb$}) { |m| "spec/controllers/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb') { 'spec' }
end
