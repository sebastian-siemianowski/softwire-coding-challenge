class Booking < ApplicationRecord
  belongs_to :event

  IN_PROGRESS_STATUS = 'in_progress'
  COMPLETED_STATUS = 'completed'
end