require 'rails_helper'

RSpec.describe BookingRequestImportBatch do

  let(:in_progress_batch){ described_class.create!(status: 'in_progress') }
  let(:import_completed_batch){ described_class.create!(status: 'import_completed') }
  let(:import_completed_batch_2){ described_class.create!(status: 'import_completed') }
  let(:completed_with_errors_batch){ described_class.create!(status: 'completed_with_errors') }

  context 'when testing scopes' do
    before(:each) do
      in_progress_batch
      import_completed_batch
      completed_with_errors_batch
    end

    it 'returns in progress batches' do
      expect(BookingRequestImportBatch.in_progress.first.status).to eq 'in_progress'
    end

    it 'returns completed batches' do
      expect(BookingRequestImportBatch.import_completed.first.status).to eq 'import_completed'
    end

    it 'returns completed with errors batches' do
      expect(BookingRequestImportBatch.completed_with_errors.first.status).to eq 'completed_with_errors'
    end

    it 'allows ordering by newest batches' do
      expect(BookingRequestImportBatch.newest_first.first.status).to eq 'completed_with_errors'
    end

    it 'allows ordering by oldest batches' do
      expect(BookingRequestImportBatch.oldest_first.first.status).to eq 'in_progress'
    end
  end
end