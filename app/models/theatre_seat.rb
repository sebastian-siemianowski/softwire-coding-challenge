# frozen_string_literal: true

class TheatreSeat < ApplicationRecord
  has_many :reservations
  belongs_to :theatre_seat_row

  scope :for_row_and_seat_indexes, ->(row_indexes, seat_indexes) { joins(:theatre_seat_row).merge(TheatreSeatRow.for_row_indexes(row_indexes)).where(seat_index: seat_indexes) }
end
