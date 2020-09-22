# frozen_string_literal: true

class BookingRequestImportBatch < ApplicationRecord
  has_many :booking_requests

  IN_PROGRESS_STATUS = 'in_progress'
  IMPORT_COMPLETED_STATUS = 'import_completed'
  IMPORT_COMPLETED_WITH_ERRORS_STATUS = 'completed_with_errors'

  scope :in_progress, -> { where(status: IN_PROGRESS_STATUS) }
  scope :import_completed, -> { where(status: IMPORT_COMPLETED_STATUS) }
  scope :completed_with_errors, -> { where(status: IMPORT_COMPLETED_WITH_ERRORS_STATUS) }
  scope :newest_first, -> { order(created_at: :desc) }
  scope :oldest_first, -> { order(created_at: :asc) }
end
