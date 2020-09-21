# frozen_string_literal: true

namespace :db do
  desc 'Setup the db or migrate depending on state of db'
  task setup_or_migrate: :environment do
    if ActiveRecord::Migrator.current_version.zero?
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke
    end
  rescue ActiveRecord::NoDatabaseError
    Rake::Task['db:setup'].invoke
  else
    Rake::Task['db:migrate'].invoke
  end

  desc 'Setup test database'
  task :setup_test_db do
    system('rake db:drop db:create db:migrate RAILS_ENV=test')
  end
end
