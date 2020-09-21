# frozen_string_literal: true

module Services
  class BookingRequestsImporter
    attr_reader :filepath
    def initialize(file_name = nil)
      raise ArgumentError, 'Filename needs to be provided' unless file_name

      @filepath = ENV['BOOKING_IMPORT_PATH'] + '/' + file_name
    end

    def import_bookings

    end

    def import_files_to_db
      batch = BookingRequestImportBatch.new
      batch.status = BookingRequestImportBatch::IN_PROGRESS_STATUS
      batch.save!

      process_all_text_file_rows(batch)

      batch.status = BookingRequestImportBatch::IMPORT_COMPLETED_STATUS unless batch.status == BookingRequestImportBatch::IMPORT_COMPLETED_WITH_ERRORS_STATUS
      batch.save!
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
      clean_array_data.each do |text_file_row|
        process_text_file_row(batch, text_file_row)
      end
    end

    def process_text_file_row(batch, text_file_row)
      booking_request                              = BookingRequest.new
      booking_request.booking_request_import_batch = batch
      begin
        booking_request.external_booking_id            = text_file_row[:external_booking_id]
        booking_request.index_of_first_seat_row        = text_file_row[:index_of_first_seat_row]
        booking_request.index_of_first_seat_within_row = text_file_row[:index_of_first_seat_within_row]
        booking_request.index_of_last_seat_row         = text_file_row[:index_of_last_seat_row]
        booking_request.index_of_last_seat_within_row  = text_file_row[:index_of_last_seat_within_row]
        booking_request.processed_status               = BookingRequest::UNPROCESSED_STATUS
        booking_request.save!
      rescue StandardError => e
        error                     = "#{e.message.to_json} + #{e.backtrace.to_json}"
        booking_request.error_log = error
        batch.status = BookingRequestImportBatch::IMPORT_COMPLETED_WITH_ERRORS_STATUS
        booking_request.save!
      end
    end
  end
end
