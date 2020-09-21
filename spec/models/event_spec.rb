require 'rails_helper'

RSpec.describe Event do
  # let(:starts_at){ DateTime.now + 1.month }
  # let(:ends_at){ DateTime.now + 1.month + 1.day }
  # let(:name){ 'Super Ser' }

  subject(:event){ Event.find_by(name: "Test Event") }

  it 'contains seeded event' do
    expect(event).to be_present
  end
end