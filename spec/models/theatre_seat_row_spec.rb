require 'rails_helper'

RSpec.describe TheatreSeatRow do
  let(:theatre){ Theatre.find_by(name: 'Test Theatre')}
  let(:theatre_seat_rows){TheatreSeatRow.where(theatre_id: theatre.id)}

  it 'contains 50 seats for all the Test Theatre rows' do
    theatre_seat_rows.each do |theatre_row|
      expect(theatre_row.theatre_seats.count).to eq 50
    end
  end

  it 'contains 100 theatre rows' do
    expect(theatre_seat_rows.count).to eq 100
  end
end