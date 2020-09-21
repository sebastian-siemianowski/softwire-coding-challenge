require 'rails_helper'

RSpec.describe TheatreSeat do
  context 'when testing scopes' do
    let(:row_index) { 10 }
    let(:seat_indexes) { [12,13,14,15] }
    it 'searches for correct row_index' do
      TheatreSeat.for_row_and_seat_indexes(row_index,seat_indexes).limit(5).each do |theatre_seat|
        expect(theatre_seat.theatre_seat_row.row_index).to eq row_index
        expect(seat_indexes).to include(theatre_seat.seat_index)
      end
    end
  end
end