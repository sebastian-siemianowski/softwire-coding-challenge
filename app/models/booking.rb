class Booking < ApplicationRecord
  belongs_to :event
  attr_accessor :seats, :row_ids, :seat_ids

  IN_PROGRESS_STATUS                      = 'in_progress'.freeze
  COMPLETED_STATUS                        = 'completed'.freeze
  FAILED_BOOKING                          = 'failed'.freeze
  TOO_MANY_BOOKINGS                       = 'failed__too_many_bookings'.freeze
  NO_SEATS_AVAILABLE                      = 'failed__no_seats_available'.freeze
  SEATS_ALREADY_TAKEN                     = 'failed__seats_already_taken'.freeze
  SEATS_ARE_NOT_ON_THE_SAME_ROW           = 'failed__seats_are_not_on_the_same_row'.freeze
  MAXIMUM_AMOUNT_OF_RESERVATIONS_EXCEEDED = 'failed__maximum_amount_of_reservations_exceeded'.freeze

  FAILED_STATUSES = [FAILED_BOOKING, TOO_MANY_BOOKINGS, NO_SEATS_AVAILABLE, SEATS_ALREADY_TAKEN,
                     SEATS_ARE_NOT_ON_THE_SAME_ROW, MAXIMUM_AMOUNT_OF_RESERVATIONS_EXCEEDED].freeze

  scope :in_progress, -> { where(status: IN_PROGRESS_STATUS) }
  scope :failed, -> { where(status: FAILED_STATUSES) }
  scope :completed, -> { where(status: COMPLETED_STATUS) }

  def create_booking_reservations
    if validations_succeeded
      seats.each { |seat| create_a_reservation(seat) }
      self.status = Booking::COMPLETED_STATUS
    end

    save!
  end

  private

  def validations_succeeded
    if seats.count <= 0
      self.status = NO_SEATS_AVAILABLE
    elsif seats_are_already_taken
      self.status = Booking::SEATS_ALREADY_TAKEN
    elsif seats_are_on_different_rows
      self.status = Booking::SEATS_ARE_NOT_ON_THE_SAME_ROW
    elsif booking_is_for_five_or_more_seats
      self.status = Booking::MAXIMUM_AMOUNT_OF_RESERVATIONS_EXCEEDED
    end
    
    true unless FAILED_STATUSES.include?(status)
  end

  def seats_are_on_different_rows
    row_ids.uniq.count > 1
  end

  def seats_are_already_taken
    Reservation.for_seats(seats.pluck(:id)).count > 0
  end

  def booking_is_for_five_or_more_seats
    seats.count > 5
  end

  def create_a_reservation(seat)
    new_reservation                 = Reservation.new
    new_reservation.theatre_seat_id = seat.id
    new_reservation.booking_id      = id
    new_reservation.save!
  end
end