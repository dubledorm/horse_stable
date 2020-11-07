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

ActiveRecord::Schema.define(version: 2020_11_06_200031) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

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

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "gallery_id"
    t.text "main_description"
    t.text "short_description"
    t.string "state", null: false
    t.string "article_type", null: false
    t.integer "min_quantity"
    t.integer "max_quantity"
    t.integer "min_age"
    t.integer "max_age"
    t.string "seo_description"
    t.string "seo_keywords"
    t.integer "duration_minutes"
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["article_type"], name: "index_articles_on_article_type"
    t.index ["gallery_id"], name: "index_articles_on_gallery_id"
    t.index ["max_age"], name: "index_articles_on_max_age"
    t.index ["max_quantity"], name: "index_articles_on_max_quantity"
    t.index ["min_age"], name: "index_articles_on_min_age"
    t.index ["min_quantity"], name: "index_articles_on_min_quantity"
    t.index ["name"], name: "index_articles_on_name"
    t.index ["state"], name: "index_articles_on_state"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "post_type", null: false
    t.bigint "gallery_id"
    t.bigint "user_id", null: false
    t.datetime "event_date"
    t.boolean "seo_flag", default: false
    t.text "content"
    t.string "title"
    t.string "state", null: false
    t.string "seo_keywords"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_date"], name: "index_blogs_on_event_date"
    t.index ["gallery_id"], name: "index_blogs_on_gallery_id"
    t.index ["post_type"], name: "index_blogs_on_post_type"
    t.index ["seo_flag"], name: "index_blogs_on_seo_flag"
    t.index ["state"], name: "index_blogs_on_state"
    t.index ["user_id"], name: "index_blogs_on_user_id"
  end

  create_table "experiment_cases", force: :cascade do |t|
    t.string "human_name"
    t.text "human_description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "number", null: false
    t.bigint "experiment_id", null: false
    t.index ["experiment_id"], name: "index_experiment_cases_on_experiment_id"
    t.index ["number"], name: "index_experiment_cases_on_number"
    t.index ["user_id"], name: "index_experiment_cases_on_user_id"
  end

  create_table "experiments", force: :cascade do |t|
    t.string "human_name"
    t.text "human_description"
    t.bigint "user_id", null: false
    t.string "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_experiments_on_user_id"
  end

  create_table "galleries", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "description"
    t.string "state", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_galleries_on_user_id"
  end

  create_table "grade_averages", force: :cascade do |t|
    t.string "object_type"
    t.bigint "object_id"
    t.integer "grade_value"
    t.integer "grade_count"
    t.string "grade_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grade_type"], name: "index_grade_averages_on_grade_type"
    t.index ["grade_value"], name: "index_grade_averages_on_grade_value"
    t.index ["object_type", "object_id"], name: "index_grade_averages_on_object_type_and_object_id"
  end

  create_table "grades", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "object_type"
    t.bigint "object_id"
    t.text "content"
    t.integer "grade_value"
    t.string "grade_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["grade_type"], name: "index_grades_on_grade_type"
    t.index ["grade_value"], name: "index_grades_on_grade_value"
    t.index ["object_type", "object_id"], name: "index_grades_on_object_type_and_object_id"
    t.index ["user_id"], name: "index_grades_on_user_id"
  end

  create_table "operations", force: :cascade do |t|
    t.string "operation_type", null: false
    t.integer "number", null: false
    t.text "operation_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "function_name"
    t.bigint "experiment_case_id"
    t.index ["experiment_case_id"], name: "index_operations_on_experiment_case_id"
    t.index ["number"], name: "index_operations_on_number"
    t.index ["operation_type"], name: "index_operations_on_operation_type"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "gallery_id", null: false
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gallery_id"], name: "index_pictures_on_gallery_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "uname"
    t.string "uemail"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "tag_type", null: false
    t.string "name", null: false
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_tags_on_name"
  end

  create_table "tags_on_objects", force: :cascade do |t|
    t.integer "tag_id", null: false
    t.integer "taggable_id", null: false
    t.string "taggable_type", null: false
    t.index ["taggable_id", "taggable_type", "tag_id"], name: "taggable_tag_id"
  end

  create_table "test_tasks", force: :cascade do |t|
    t.text "test_setting_json", null: false
    t.integer "duration"
    t.datetime "start_time"
    t.string "result_kod"
    t.text "result_values_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "state"
    t.bigint "operation_id"
    t.string "result_message"
    t.index ["operation_id"], name: "index_test_tasks_on_operation_id"
    t.index ["result_kod"], name: "index_test_tasks_on_result_kod"
    t.index ["start_time"], name: "index_test_tasks_on_start_time"
    t.index ["state"], name: "index_test_tasks_on_state"
  end

  create_table "user_parameters", force: :cascade do |t|
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_parameters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "nick_name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["nick_name"], name: "index_users_on_nick_name"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "galleries"
  add_foreign_key "articles", "users"
  add_foreign_key "blogs", "galleries"
  add_foreign_key "blogs", "users"
  add_foreign_key "experiment_cases", "experiments"
  add_foreign_key "experiment_cases", "users"
  add_foreign_key "experiments", "users"
  add_foreign_key "grades", "users"
  add_foreign_key "pictures", "galleries"
  add_foreign_key "test_tasks", "operations"
  add_foreign_key "user_parameters", "users"
end
