class TheatreSeat < ApplicationRecord
  has_many :reservations
  belongs_to :theatre_seat_row

  scope :for_row_indexes, ->(row_indexes) { joins(:theatre_seat_row).where('theatre_seat_rows.row_index = ?', row_indexes)}
  scope :for_seat_indexes, ->(seat_indexes) {where(seat_index: seat_indexes) }
end