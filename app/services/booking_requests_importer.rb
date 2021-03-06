# frozen_string_literal: true

module Services
  class BookingRequestsImporter
    attr_reader :filepath, :event
    def initialize(file_name = nil)
      raise ArgumentError, 'Filename needs to be provided' unless file_name

      @event = ::Event.find_by(name: 'Test Event')

      @filepath = ENV['BOOKING_IMPORT_PATH'] + '/' + file_name
    end

    def process_booking_file
      Rails.logger.info 'Starting Import of Booking Requests to database' unless ENV['RAILS_ENV'] == 'test'
      batch = import_files_to_db
      Rails.logger.info 'Completed Import of Booking Requests to database' unless ENV['RAILS_ENV'] == 'test'

      Rails.logger.info 'Starting Processing Booking Requests from db' unless ENV['RAILS_ENV'] == 'test'
      Rails.logger.info "Found #{batch.booking_requests.count} Booking Requests ready to be processed" unless ENV['RAILS_ENV'] == 'test'

      successful_bookings = []
      unsuccessful_bookings = []

      batch.booking_requests.each do |booking_request|
        row_ids = (booking_request.index_of_first_seat_row..booking_request.index_of_last_seat_row).to_a
        seat_ids = (booking_request.index_of_first_seat_within_row..booking_request.index_of_first_seat_within_row).to_a
        seats = TheatreSeat.for_row_and_seat_indexes(row_ids, seat_ids)
        new_booking = Booking.create!(status: Booking::IN_PROGRESS_STATUS, external_booking_id: booking_request.external_booking_id, event: event)
        new_booking.seats = seats
        new_booking.row_ids = row_ids
        new_booking.seat_ids = seat_ids
        new_booking.create_booking_reservations

        if ::Booking::FAILED_STATUSES.include?(new_booking.status)
          unsuccessful_bookings << new_booking
        elsif new_booking.status == ::Booking::COMPLETED_STATUS
          successful_bookings << new_booking
        end
      end

      Rails.logger.info 'Completed Processing Booking Request Records' unless ENV['RAILS_ENV'] == 'test'
      Rails.logger.info "#{successful_bookings.count} Successful Bookings had been created" unless ENV['RAILS_ENV'] == 'test'
      Rails.logger.info "#{unsuccessful_bookings.count} Bookings failed - This would happen if Booking Request did not pass validation" unless ENV['RAILS_ENV'] == 'test'
    end

    def import_files_to_db
      batch = BookingRequestImportBatch.new
      batch.status = BookingRequestImportBatch::IN_PROGRESS_STATUS
      batch.save!

      process_all_text_file_rows(batch)

      unless batch.status == BookingRequestImportBatch::IMPORT_COMPLETED_WITH_ERRORS_STATUS
        batch.status = BookingRequestImportBatch::IMPORT_COMPLETED_STATUS
      end
      batch.save!
      batch
    end

    def clean_array_data
      raw_data = File.readlines(filepath, chomp: true)
      raw_data.map do |row_data_row|
        cleaned_string = row_data_row.gsub('(', '').gsub('),', '')
        spliced_array = cleaned_string.split(/[:,]/).map(&:to_i)
        { external_booking_id:            spliced_array[0],
          index_of_first_seat_row:        spliced_array[1],
          index_of_first_seat_within_row: spliced_array[2],
          index_of_last_seat_row:         spliced_array[3],
          index_of_last_seat_within_row:  spliced_array[4] }
      end
    end

    private

    def process_all_text_file_rows(batch)
      clean_array_data.each { |text_file_row| process_text_file_row(batch, text_file_row) }
    end

    def process_text_file_row(batch, text_file_row)
      booking_request                              = BookingRequest.new
      booking_request.booking_request_import_batch = batch

      begin
        map_values_to_booking_request(booking_request, text_file_row)
      rescue StandardError => e
        error                     = "#{e.message.to_json} + #{e.backtrace.to_json}"
        booking_request.error_log = error
        batch.status = BookingRequestImportBatch::IMPORT_COMPLETED_WITH_ERRORS_STATUS
        booking_request.save!
      end
    end

    def map_values_to_booking_request(booking_request, text_file_row)
      booking_request.external_booking_id            = text_file_row[:external_booking_id]
      booking_request.index_of_first_seat_row        = text_file_row[:index_of_first_seat_row]
      booking_request.index_of_first_seat_within_row = text_file_row[:index_of_first_seat_within_row]
      booking_request.index_of_last_seat_row         = text_file_row[:index_of_last_seat_row]
      booking_request.index_of_last_seat_within_row  = text_file_row[:index_of_last_seat_within_row]
      booking_request.processed_status               = BookingRequest::UNPROCESSED_STATUS
      booking_request.save!
    end
  end
end
