require 'rails_helper'

RSpec.describe Theatre do
  subject(:theatre){Theatre.first}

  it 'contains 100 seat rows' do
    expect(theatre.theatre_seat_rows.count).to eq 100
  end
end