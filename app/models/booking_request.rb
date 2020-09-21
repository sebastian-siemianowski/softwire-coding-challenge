class BookingRequest < ApplicationRecord
  UNPROCESSED_STATUS = "unprocessed".freeze
  PROCESSED_STATUS = "processed".freeze
  FAILED_STATUS = "failed"
  DUPLICATE_SKIPPED_STATUS = "duplicate_skipped"
  
  belongs_to :booking_request_import_batch
end