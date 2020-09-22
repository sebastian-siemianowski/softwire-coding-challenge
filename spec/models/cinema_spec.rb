require 'rails_helper'

RSpec.describe Cinema do
  subject(:cinema) { Cinema.first }
  it 'contains test cinema' do
    expect(cinema.name).to eq 'Test Cinema'
  end

  it 'contains test theatre' do
    expect(cinema.theatres.first.name).to eq 'Test Theatre'
  end
end