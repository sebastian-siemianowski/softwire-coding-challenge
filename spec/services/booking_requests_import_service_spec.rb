# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Services::BookingRequestsImporter do
  let(:file_name){ 'sample_booking_requests' }
  let(:filepath){ ENV['BOOKING_IMPORT_PATH'] + "/" + file_name }
  subject(:importer){ described_class.new(file_name) }

  it 'contains the reference to the booking requests file' do
    expect(importer.filepath).to eq filepath
  end

  it 'imports the booking request data to database' do
    expect { importer.import_files_to_db }.to change { BookingRequestImportBatch.count && BookingRequest.count }
  end

  it 'creates successful bookings' do
    importer.import_files_to_db

    expect { importer.process_booking_file }.to change { Booking.count }
  end

  it 'creates successful reservations' do
    importer.import_files_to_db

    expect { importer.process_booking_file }.to change { Reservation.count }
  end

  # it 'creates failed bookings which have not passed validation' do
  #   importer.import_files_to_db
  #   importer.process_booking_file
  #   expect(Booking.failed_bookings.count).to eq 10
  # end
end
