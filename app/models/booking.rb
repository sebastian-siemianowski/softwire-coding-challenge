class Booking < ApplicationRecord
  belongs_to :event
  attr_accessor :seats

  IN_PROGRESS_STATUS = 'in_progress'
  COMPLETED_STATUS   = 'completed'
  FAILED_BOOKING    = 'failed'
  TOO_MANY_BOOKINGS  = 'failed__too_many_bookings'
  NO_SEATS_AVAILABLE = 'failed__no_seats_available'
  SEATS_ALREADY_TAKEN = 'failed__seats_already_taken'

  scope :in_progress, -> { where(status: IN_PROGRESS_STATUS) }
  scope :failed, -> { where(status: [FAILED_BOOKING, TOO_MANY_BOOKINGS, NO_SEATS_AVAILABLE, SEATS_ALREADY_TAKEN]) }
  scope :completed, -> { where(status: COMPLETED_STATUS) }

  def create_booking_reservations
    if seats.count <= 0
      self.status = NO_SEATS_AVAILABLE
    elsif Reservation.for_seats(seats.pluck(:id)).count > 0
      self.status = Booking::SEATS_ALREADY_TAKEN
    elsif booking_is_for_five_or_fewer_seats
      seats.each { |seat| create_a_reservation(seat) }
      self.status = Booking::COMPLETED_STATUS
    else
      self.status = Booking::FAILED_BOOKING
    end

    save!
  end

  private

  def booking_is_for_five_or_fewer_seats
    seats.count <= 5
  end

  def create_a_reservation(seat)
    new_reservation                 = Reservation.new
    new_reservation.theatre_seat_id = seat.id
    new_reservation.booking_id      = id
    new_reservation.save!
  end
end