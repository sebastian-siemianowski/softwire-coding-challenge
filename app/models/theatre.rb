class Theatre < ApplicationRecord
  belongs_to :cinema
  has_many :theatre_seat_rows
end