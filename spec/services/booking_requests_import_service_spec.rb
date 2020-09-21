# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Services::BookingRequestsImporter do
  let(:file_name){ 'sample_booking_requests' }
  let(:filepath){ ENV['BOOKING_IMPORT_PATH'] + "/" + file_name }
  subject(:importer){ described_class.new(file_name) }

  it 'contains the reference to the booking requests file' do
    expect(importer.filepath).to eq filepath
  end

  fit 'imports the booking request data to database' do
    expect { importer.import_files_to_db }.to change { BookingRequestImportBatch.count && BookingRequest.count }
  end
end
