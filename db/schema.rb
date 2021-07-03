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

ActiveRecord::Schema.define(version: 2021_07_03_070818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "consumers", force: :cascade do |t|
    t.string "name"
    t.text "full_name"
    t.string "edrpou"
    t.integer "onec_id"
    t.string "director_name"
    t.string "engineer_name"
    t.string "dog_num"
    t.date "dog_date"
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
    t.string "director_phone"
    t.string "director_mail"
    t.string "engineer_phone"
    t.string "engineer_mail"
    t.string "accountant_name"
    t.string "accountant_phone"
    t.string "accountant_mail"
    t.boolean "has_hourly", default: false
  end

  create_table "consumers_users", id: false, force: :cascade do |t|
    t.bigint "consumer_id"
    t.bigint "user_id"
    t.index ["consumer_id"], name: "index_consumers_users_on_consumer_id"
    t.index ["user_id"], name: "index_consumers_users_on_user_id"
  end

  create_table "current_en_consumptions", force: :cascade do |t|
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
    t.decimal "next_tariff", precision: 13, scale: 8
    t.index ["consumer_id"], name: "index_current_en_consumptions_on_consumer_id"
  end

  create_table "current_gas_consumptions", force: :cascade do |t|
    t.date "date"
    t.decimal "opening_balance"
    t.integer "volume"
    t.decimal "tariff"
    t.decimal "cost"
    t.decimal "cost_val"
    t.decimal "money"
    t.decimal "closing_balance"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "next_tariff", precision: 10, scale: 5
    t.index ["consumer_id"], name: "index_current_gas_consumptions_on_consumer_id"
  end

  create_table "d_companies", force: :cascade do |t|
    t.string "name"
    t.boolean "operational"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "d_tariffs", force: :cascade do |t|
    t.decimal "class_one"
    t.decimal "class_two"
    t.date "start_date"
    t.string "decree"
    t.date "decree_date"
    t.bigint "d_company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["d_company_id"], name: "index_d_tariffs_on_d_company_id"
  end

  create_table "dailies", force: :cascade do |t|
    t.integer "day_cons"
    t.bigint "monthly_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["monthly_id"], name: "index_dailies_on_monthly_id"
  end

  create_table "en_adjustments", force: :cascade do |t|
    t.integer "month"
    t.bigint "value"
    t.text "comment"
    t.integer "state", default: 0
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_en_adjustments_on_consumer_id"
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

  create_table "en_certificates", force: :cascade do |t|
    t.bigint "consumer_id"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_en_certificates_on_consumer_id"
  end

  create_table "en_payments", force: :cascade do |t|
    t.integer "day"
    t.integer "percent"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "month", default: 0
    t.index ["consumer_id"], name: "index_en_payments_on_consumer_id"
  end

  create_table "gas_adjustments", force: :cascade do |t|
    t.integer "month"
    t.bigint "value"
    t.text "comment"
    t.integer "state", default: 0
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_gas_adjustments_on_consumer_id"
  end

  create_table "gas_bids", force: :cascade do |t|
    t.integer "jan", default: 0
    t.integer "feb", default: 0
    t.integer "mar", default: 0
    t.integer "apr", default: 0
    t.integer "may", default: 0
    t.integer "jun", default: 0
    t.integer "jul", default: 0
    t.integer "aug", default: 0
    t.integer "sep", default: 0
    t.integer "okt", default: 0
    t.integer "nov", default: 0
    t.integer "dec", default: 0
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_gas_bids_on_consumer_id"
  end

  create_table "gas_certificates", force: :cascade do |t|
    t.bigint "consumer_id"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_gas_certificates_on_consumer_id"
  end

  create_table "gas_payments", force: :cascade do |t|
    t.integer "day"
    t.integer "percent"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "month", default: 0
    t.index ["consumer_id"], name: "index_gas_payments_on_consumer_id"
  end

  create_table "hourlies", force: :cascade do |t|
    t.integer "hour_cons"
    t.decimal "w", precision: 8, scale: 2
    t.bigint "daily_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["daily_id"], name: "index_hourlies_on_daily_id"
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

  create_table "monthlies", force: :cascade do |t|
    t.date "date_cons"
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_monthlies_on_consumer_id"
  end

  create_table "previous_en_consumptions", force: :cascade do |t|
    t.date "date"
    t.decimal "opening_balance", precision: 13, scale: 2
    t.integer "power"
    t.decimal "tariff", precision: 13, scale: 8
    t.decimal "cost", precision: 13, scale: 2
    t.decimal "cost_val", precision: 13, scale: 2
    t.decimal "money", precision: 13, scale: 2
    t.decimal "closing_balance", precision: 13, scale: 2
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_previous_en_consumptions_on_consumer_id"
  end

  create_table "previous_gas_consumptions", force: :cascade do |t|
    t.date "date"
    t.decimal "opening_balance", precision: 13, scale: 2
    t.decimal "volume", precision: 13, scale: 3
    t.decimal "tariff", precision: 10, scale: 5
    t.decimal "cost", precision: 13, scale: 2
    t.decimal "cost_val", precision: 13, scale: 2
    t.decimal "money", precision: 13, scale: 2
    t.decimal "closing_balance", precision: 13, scale: 2
    t.bigint "consumer_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consumer_id"], name: "index_previous_gas_consumptions_on_consumer_id"
  end

  create_table "receivers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "edrpou"
    t.bigint "ipn"
    t.string "account"
    t.string "bank"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "buh_name"
    t.string "buh_phone"
    t.string "buh_mail"
    t.string "dog_name"
    t.string "dog_phone"
    t.string "dog_mail"
    t.string "teh_name"
    t.string "teh_phone"
    t.string "teh_mail"
    t.string "com_name"
    t.string "com_phone"
    t.string "com_mail"
    t.string "account_gas"
    t.string "bank_gas"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "admin_role", default: false
    t.boolean "manager_role", default: false
    t.boolean "client_role", default: true
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "phone"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "current_en_consumptions", "consumers"
  add_foreign_key "current_gas_consumptions", "consumers"
  add_foreign_key "d_tariffs", "d_companies"
  add_foreign_key "dailies", "monthlies"
  add_foreign_key "en_adjustments", "consumers"
  add_foreign_key "en_bids", "consumers"
  add_foreign_key "en_payments", "consumers"
  add_foreign_key "gas_adjustments", "consumers"
  add_foreign_key "gas_bids", "consumers"
  add_foreign_key "gas_payments", "consumers"
  add_foreign_key "hourlies", "dailies"
  add_foreign_key "messages", "consumers"
  add_foreign_key "monthlies", "consumers"
  add_foreign_key "previous_en_consumptions", "consumers"
  add_foreign_key "previous_gas_consumptions", "consumers"
end
