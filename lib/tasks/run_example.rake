namespace :softwire do


  desc 'Setup Databases'
  task :setup_databases => :environment do
    system('rake db:drop db:create db:migrate db:seed')
  end

  desc 'Import Bookings'
  task :import_bookings => :environment do
    ::Services::BookingRequestsImporter.new('booking_requests').process_booking_file
  end
end