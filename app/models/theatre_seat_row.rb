class TheatreSeatRow < ApplicationRecord
  has_many :theatre_seats
  belongs_to :theatre

  scope :for_row_indexes, ->(row_indexes) {where(row_index: row_indexes) }
end