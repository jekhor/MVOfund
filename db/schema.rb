# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161215235726) do

  create_table "budget_items", force: :cascade do |t|
    t.integer  "campaign_id",                                          null: false
    t.string   "title"
    t.decimal  "amount",      precision: 12, scale: 2, default: "0.0"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "is_expense",                           default: false, null: false
    t.index ["campaign_id"], name: "index_budget_items_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string   "title",                                                      null: false
    t.text     "description",                                                null: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.decimal  "target",            precision: 12, scale: 2, default: "0.0"
    t.date     "end_date"
    t.text     "short_description",                          default: "",    null: false
    t.integer  "title_image_id"
    t.index ["title_image_id"], name: "index_campaigns_on_title_image_id"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "time"
    t.decimal  "amount",         precision: 12, scale: 2,                 null: false
    t.string   "contributor"
    t.text     "notes"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "campaign_id"
    t.integer  "budget_item_id"
    t.boolean  "is_expense",                              default: false, null: false
    t.string   "payment_number"
    t.index ["budget_item_id"], name: "index_payments_on_budget_item_id"
  end

  create_table "post_images", force: :cascade do |t|
    t.string   "image_secure_token"
    t.string   "original_filename"
    t.string   "image"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
