class TheatreSeatRow < ApplicationRecord
  has_many :theatre_seats
  belongs_to :theatre
end