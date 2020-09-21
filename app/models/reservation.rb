class Reservation < ApplicationRecord
  belongs_to :booking
  belongs_to :theatre_seat
end