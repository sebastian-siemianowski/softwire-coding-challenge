# frozen_string_literal: true

namespace :db do
  desc 'Setup test database'
  task :setup_test_db do
    system('rake db:drop db:create db:migrate db:seed RAILS_ENV=test')
  end

  desc 'Setup normal database'
  task :setup_test_db do
    system('rake db:drop db:create db:migrate db:seed')
  end
end
