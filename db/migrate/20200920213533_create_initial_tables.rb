class CreateInitialTables < ActiveRecord::Migration[6.0]
  def change
    create_table :cinemas do |t|
      t.column :name, :string, null: false
      t.index :name
      t.timestamps
    end

    create_table :theatres do |t|
      t.references :cinema, foreign_key: true
      t.column :name, :string, null: false
      t.index :name
      t.timestamps
    end

    create_table :theatre_seat_rows do |t|
      t.references :theatre, foreign_key: true
      t.column :row_index, :integer, null: false
      t.index :row_index
      t.timestamps
    end

    create_table :theatre_seats do |t|
      t.references :theatre_seat_row, foreign_key: true
      t.column :seat_index, :integer, null: false
      t.index :seat_index
      t.timestamps
    end

    create_table :events do |t|
      t.column :name, :string, null: false
      t.index :name
      t.column :starts_at, :datetime, null: false
      t.column :ends_at, :datetime, null: false
      t.timestamps
    end

    create_table :bookings do |t|
      t.references :event, foreign_key: true
      t.column :external_booking_id, :integer, null: false
      t.index :external_booking_id
      t.column :status, :string, null: false
      t.timestamps
    end

    create_table :reservations do |t|
      t.references :booking, foreign_key: true
      t.references :theatre_seat, foreign_key: true
      t.string :state, default: :active, null: false
      t.timestamps
    end

    create_table :booking_request_import_batches do |t|
      t.column :status, :string
      t.column :error_log, :text
      t.timestamps
    end

    create_table :booking_requests do |t|
      t.references :booking_request_import_batch, foreign_key: true
      t.column :external_booking_id, :integer, null: false
      t.index :external_booking_id
      t.column :index_of_first_seat_row, :integer, null: false
      t.column :index_of_first_seat_within_row, :integer, null: false
      t.column :index_of_last_seat_row, :integer, null: false
      t.column :index_of_last_seat_within_row, :integer, null: false
      t.column :processed_status, :boolean
      t.column :error_log, :text
      t.timestamps
    end
  end
end
