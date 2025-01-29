# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_04_04_225745) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "lessons", force: :cascade do |t|
    t.date "date"
    t.integer "style_id", null: false
  end

  create_table "lessons_students", id: false, force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.bigint "student_id", null: false
    t.bigint "subscription_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["lesson_id", "student_id", "subscription_id"], name: "index_lessons_students_subscriptions"
    t.index ["lesson_id", "student_id"], name: "index_lessons_students_on_lesson_id_and_student_id", unique: true
    t.index ["lesson_id"], name: "index_lessons_students_on_lesson_id"
    t.index ["student_id"], name: "index_lessons_students_on_student_id"
    t.index ["subscription_id"], name: "index_lessons_students_on_subscription_id"
  end

  create_table "lessons_users", id: false, force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["lesson_id", "user_id"], name: "index_lessons_users_on_lesson_id_and_user_id", unique: true
    t.index ["lesson_id"], name: "index_lessons_users_on_lesson_id"
    t.index ["user_id"], name: "index_lessons_users_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "middlename"
    t.string "phone_number"
    t.string "email"
    t.string "vk_profile"
    t.text "comment"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.date "birthday"
  end

  create_table "styles", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "duration_hours", precision: 4, scale: 2, default: "1.0", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "calculate_payrolls", default: true, null: false
    t.boolean "party_subscription", default: false, null: false
    t.boolean "visible", default: true, null: false
    t.index ["name"], name: "index_styles_on_name", unique: true
  end

  create_table "styles_users", id: false, force: :cascade do |t|
    t.bigint "style_id", null: false
    t.bigint "user_id", null: false
    t.index ["style_id", "user_id"], name: "index_styles_users_on_style_id_and_user_id", unique: true
    t.index ["style_id"], name: "index_styles_users_on_style_id"
    t.index ["user_id"], name: "index_styles_users_on_user_id"
  end

  create_table "subscription_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number_of_lessons", default: 1, null: false
    t.decimal "cost", precision: 8, scale: 2, default: "300.0", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "duration_months", default: 0, null: false
    t.integer "duration_weeks", default: 4, null: false
    t.boolean "active", default: true, null: false
    t.boolean "visible", default: true, null: false
    t.boolean "party_subscription", default: false, null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "subscription_type_id", null: false
    t.bigint "student_id", null: false
    t.date "purchase_date", null: false
    t.date "expiry_date"
    t.decimal "price", default: "0.0", null: false
    t.bigint "paired_with_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id", null: false
    t.boolean "no_expiry", default: false, null: false
    t.integer "number_of_lessons", default: 0, null: false
    t.decimal "lesson_price", default: "0.0", null: false
    t.index ["paired_with_id"], name: "index_subscriptions_on_paired_with_id"
    t.index ["student_id"], name: "index_subscriptions_on_student_id"
    t.index ["subscription_type_id"], name: "index_subscriptions_on_subscription_type_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "firstname", null: false
    t.string "lastname", null: false
    t.string "middlename"
    t.boolean "banned", default: false, null: false
    t.text "comment"
    t.boolean "hidden", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", unique: true
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "lessons", "styles"
  add_foreign_key "lessons_students", "lessons"
  add_foreign_key "lessons_students", "students"
  add_foreign_key "lessons_students", "subscriptions"
  add_foreign_key "lessons_users", "lessons"
  add_foreign_key "lessons_users", "users"
  add_foreign_key "styles_users", "styles"
  add_foreign_key "styles_users", "users"
  add_foreign_key "subscriptions", "students"
  add_foreign_key "subscriptions", "subscription_types"
  add_foreign_key "subscriptions", "subscriptions", column: "paired_with_id"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users_roles", "roles"
  add_foreign_key "users_roles", "users"
end
