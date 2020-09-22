# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#

cinema = Cinema.find_or_create_by!(name: 'Test Cinema')

theatre = cinema.theatres.find_or_create_by!(name: 'Test Theatre')


row_numbers = (0 .. 99).to_a

row_numbers.each do |row_number|
  theatre_seat_row = TheatreSeatRow.find_or_create_by!(row_index: row_number, theatre_id: theatre.id)

  if theatre_seat_row.theatre_seats.count == 0
    seat_numbers = (0 .. 49)

    seat_numbers.each do |seat_number|
      TheatreSeat.find_or_create_by!(seat_index: seat_number, theatre_seat_row_id: theatre_seat_row.id)
    end
  end
end

event = Event.find_or_initialize_by(name: 'Test Event')
event.starts_at = DateTime.now + 1.month
event.ends_at = DateTime.now + 1.month + 1.day
event.save!

