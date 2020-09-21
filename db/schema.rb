# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_20_213533) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "booking_request_import_batches", force: :cascade do |t|
    t.string "status"
    t.text "error_log"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "booking_requests", force: :cascade do |t|
    t.bigint "booking_request_import_batch_id"
    t.integer "external_booking_id", null: false
    t.integer "index_of_first_seat_row", null: false
    t.integer "index_of_first_seat_within_row", null: false
    t.integer "index_of_last_seat_row", null: false
    t.integer "index_of_last_seat_within_row", null: false
    t.boolean "processed_status"
    t.text "error_log"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_request_import_batch_id"], name: "index_booking_requests_on_booking_request_import_batch_id"
    t.index ["external_booking_id"], name: "index_booking_requests_on_external_booking_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "event_id"
    t.integer "external_booking_id", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_bookings_on_event_id"
    t.index ["external_booking_id"], name: "index_bookings_on_external_booking_id"
  end

  create_table "cinemas", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_cinemas_on_name"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_events_on_name"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "booking_id"
    t.bigint "theatre_seat_id"
    t.string "state", default: "active", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_reservations_on_booking_id"
    t.index ["theatre_seat_id"], name: "index_reservations_on_theatre_seat_id"
  end

  create_table "theatre_seat_rows", force: :cascade do |t|
    t.bigint "theatre_id"
    t.integer "row_index", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["row_index"], name: "index_theatre_seat_rows_on_row_index"
    t.index ["theatre_id"], name: "index_theatre_seat_rows_on_theatre_id"
  end

  create_table "theatre_seats", force: :cascade do |t|
    t.bigint "theatre_seat_row_id"
    t.integer "seat_index", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["seat_index"], name: "index_theatre_seats_on_seat_index"
    t.index ["theatre_seat_row_id"], name: "index_theatre_seats_on_theatre_seat_row_id"
  end

  create_table "theatres", force: :cascade do |t|
    t.bigint "cinema_id"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cinema_id"], name: "index_theatres_on_cinema_id"
    t.index ["name"], name: "index_theatres_on_name"
  end

  add_foreign_key "booking_requests", "booking_request_import_batches"
  add_foreign_key "bookings", "events"
  add_foreign_key "reservations", "bookings"
  add_foreign_key "reservations", "theatre_seats"
  add_foreign_key "theatre_seat_rows", "theatres"
  add_foreign_key "theatre_seats", "theatre_seat_rows"
  add_foreign_key "theatres", "cinemas"
end
