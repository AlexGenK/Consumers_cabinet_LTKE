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

ActiveRecord::Schema.define(version: 2020_12_11_143017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "consumers", force: :cascade do |t|
    t.string "name"
    t.text "full_name"
    t.string "edrpou"
    t.integer "onec_id"
    t.string "director_name"
    t.string "engineer_name"
    t.string "dog_en_num"
    t.date "dog_en_date"
    t.string "dog_gas_num"
    t.date "dog_gas_date"
    t.boolean "energy_consumer"
    t.boolean "gas_consumer"
    t.string "client_username"
    t.string "manager_en_username"
    t.string "manager_gas_username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
  end

  create_table "en_bids", force: :cascade do |t|
    t.integer "jan_a_1", default: 0
    t.integer "jan_a_2", default: 0
    t.integer "jan_b_1", default: 0
    t.integer "jan_b_2", default: 0
    t.integer "feb_a_1", default: 0
    t.integer "feb_a_2", default: 0
    t.integer "feb_b_1", default: 0
    t.integer "feb_b_2", default: 0
    t.integer "mar_a_1", default: 0
    t.integer "mar_a_2", default: 0
    t.integer "mar_b_1", default: 0
    t.integer "mar_b_2", default: 0
    t.integer "apr_a_1", default: 0
    t.integer "apr_a_2", default: 0
    t.integer "apr_b_1", default: 0
    t.integer "apr_b_2", default: 0
    t.integer "may_a_1", default: 0
    t.integer "may_a_2", default: 0
    t.integer "may_b_1", default: 0
    t.integer "may_b_2", default: 0
    t.integer "jun_a_1", default: 0
    t.integer "jun_a_2", default: 0
    t.integer "jun_b_1", default: 0
    t.integer "jun_b_2", default: 0
    t.integer "jul_a_1", default: 0
    t.integer "jul_a_2", default: 0
    t.integer "jul_b_1", default: 0
    t.integer "jul_b_2", default: 0
    t.integer "aug_a_1", default: 0
    t.integer "aug_a_2", default: 0
    t.integer "aug_b_1", default: 0
    t.integer "aug_b_2", default: 0
    t.integer "sep_a_1", default: 0
    t.integer "sep_a_2", default: 0
    t.integer "sep_b_1", default: 0
    t.integer "sep_b_2", default: 0
    t.integer "okt_a_1", default: 0
    t.integer "okt_a_2", default: 0
    t.integer "okt_b_1", default: 0
    t.integer "okt_b_2", default: 0
    t.integer "nov_a_1", default: 0
    t.integer "nov_a_2", default: 0
    t.integer "nov_b_1", default: 0
    t.integer "nov_b_2", default: 0
    t.integer "dec_a_1", default: 0
    t.integer "dec_a_2", default: 0
    t.integer "dec_b_1", default: 0
    t.integer "dec_b_2", default: 0
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_en_bids_on_consumer_id"
  end

  create_table "en_payments", force: :cascade do |t|
    t.integer "day"
    t.integer "percent"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_en_payments_on_consumer_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "text"
    t.text "comment"
    t.integer "state", default: 0
    t.boolean "gas"
    t.boolean "energy"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_messages_on_consumer_id"
  end

  create_table "previous_en_consumptions", force: :cascade do |t|
    t.date "date"
    t.decimal "opening_balance", precision: 13, scale: 2
    t.integer "power"
    t.decimal "tariff", precision: 10, scale: 5
    t.decimal "cost", precision: 13, scale: 2
    t.decimal "cost_val", precision: 13, scale: 2
    t.decimal "money", precision: 13, scale: 2
    t.decimal "closing_balance", precision: 13, scale: 2
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_previous_en_consumptions_on_consumer_id"
  end

  add_foreign_key "en_bids", "consumers"
  add_foreign_key "en_payments", "consumers"
  add_foreign_key "messages", "consumers"
  add_foreign_key "previous_en_consumptions", "consumers"
end
