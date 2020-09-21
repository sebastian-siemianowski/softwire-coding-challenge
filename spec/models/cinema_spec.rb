require 'rails_helper'

RSpec.describe Cinema do
  it 'contains test cinema' do
    expect(Cinema.first.name).to eq 'Test Cinema'
  end
end