# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :booking
  belongs_to :theatre_seat

  scope :for_seats, ->(ids) { joins(:theatre_seat).merge(TheatreSeat.where(id: ids)) }
end
