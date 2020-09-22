require 'rails_helper'

RSpec.describe Event do
  subject(:event){ Event.find_by(name: "Test Event") }

  it 'contains seeded event' do
    expect(event).to be_present
  end
end