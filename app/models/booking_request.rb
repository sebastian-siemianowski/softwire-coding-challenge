# frozen_string_literal: true

class BookingRequest < ApplicationRecord
  UNPROCESSED_STATUS = 'unprocessed'
  PROCESSED_STATUS = 'processed'
  FAILED_STATUS = 'failed'
  DUPLICATE_SKIPPED_STATUS = 'duplicate_skipped'

  belongs_to :booking_request_import_batch
end
