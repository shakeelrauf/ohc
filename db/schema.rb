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

ActiveRecord::Schema.define(version: 2021_05_26_094336) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "attendances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "code"
    t.bigint "camp_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "cabin_id"
    t.index ["cabin_id"], name: "index_attendances_on_cabin_id"
    t.index ["camp_id"], name: "index_attendances_on_camp_id"
    t.index ["code"], name: "index_attendances_on_code"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "authentication_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "type"
    t.string "token"
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "authentication_id"
    t.index ["authentication_id"], name: "index_authentication_tokens_on_authentication_id"
    t.index ["type", "updated_at"], name: "index_authentication_tokens_on_user_id_and_type_and_updated_at"
  end

  create_table "authentications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cabins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "camp_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "gender", default: "mixed"
    t.string "chat_guid"
    t.bigint "welcome_video_id"
    t.index ["camp_id"], name: "index_cabins_on_camp_id"
    t.index ["chat_guid"], name: "index_cabins_on_chat_guid"
    t.index ["welcome_video_id"], name: "index_cabins_on_welcome_video_id"
  end

  create_table "camp_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.string "notification_email"
    t.index ["tenant_id"], name: "index_camp_locations_on_tenant_id"
  end

  create_table "camper_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "admin_id"
    t.bigint "child_id"
    t.text "text"
    t.text "reply"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "read", default: false
    t.bigint "attendance_id"
    t.bigint "tenant_id"
    t.index ["admin_id"], name: "index_camper_questions_on_admin_id"
    t.index ["attendance_id"], name: "index_camper_questions_on_attendance_id"
    t.index ["child_id"], name: "index_camper_questions_on_child_id"
    t.index ["tenant_id"], name: "index_camper_questions_on_tenant_id"
  end

  create_table "camps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "chat_guid"
    t.bigint "season_id"
    t.bigint "welcome_video_id"
    t.index ["chat_guid"], name: "index_camps_on_chat_guid"
    t.index ["season_id"], name: "index_camps_on_season_id"
    t.index ["welcome_video_id"], name: "index_camps_on_welcome_video_id"
  end

  create_table "color_themes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "primary_color"
    t.string "secondary_color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "app_layout"
  end

  create_table "contact_email_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.text "text"
    t.string "identifier"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.index ["tenant_id"], name: "index_contact_email_messages_on_tenant_id"
    t.index ["user_id"], name: "index_contact_email_messages_on_user_id"
  end

  create_table "custom_labels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "class_name"
    t.string "singular"
    t.string "plural"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "locale", default: "en"
    t.index ["tenant_id"], name: "index_custom_labels_on_tenant_id"
  end

  create_table "device_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "token"
    t.string "device_operating_system"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "event_targets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "event_id"
    t.string "target_type"
    t.bigint "target_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_targets_on_event_id"
    t.index ["target_type", "target_id"], name: "index_event_targets_on_target_type_and_target_id"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "status", default: "closed"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "admin_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "chat_guid"
    t.boolean "active", default: true
    t.string "slug"
    t.string "type"
    t.bigint "tenant_id"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.string "key"
    t.index ["admin_id"], name: "index_events_on_admin_id"
    t.index ["chat_guid"], name: "index_events_on_chat_guid"
    t.index ["tenant_id"], name: "index_events_on_tenant_id"
  end

  create_table "imports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "error"
    t.string "status", default: "queued"
    t.string "job_id"
    t.integer "percent_completion"
    t.string "scope_type"
    t.bigint "scope_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.index ["scope_type", "scope_id"], name: "index_imports_on_scope_type_and_scope_id"
    t.index ["tenant_id"], name: "index_imports_on_tenant_id"
  end

  create_table "media_items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "camp_id"
    t.bigint "user_id", null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.string "type"
    t.index ["camp_id"], name: "index_media_items_on_camp_id"
    t.index ["tenant_id"], name: "index_media_items_on_tenant_id"
    t.index ["user_id"], name: "index_media_items_on_user_id"
  end

  create_table "quiz_answers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "text"
    t.boolean "correct", default: false
    t.bigint "quiz_question_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["quiz_question_id"], name: "index_quiz_answers_on_quiz_question_id"
  end

  create_table "quiz_questions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "text"
    t.bigint "theme_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["theme_id"], name: "index_quiz_questions_on_theme_id"
  end

  create_table "scores", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "value"
    t.bigint "user_id"
    t.string "scope_type"
    t.bigint "scope_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["scope_type", "scope_id"], name: "index_scores_on_scope_type_and_scope_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "seasons", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "camp_location_id"
    t.index ["camp_location_id"], name: "index_seasons_on_camp_location_id"
  end

  create_table "settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "visible", default: false
    t.index ["name"], name: "index_settings_on_name", unique: true
  end

  create_table "streams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "aws_input_id"
    t.string "aws_channel_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "event_id"
    t.string "slug"
    t.index ["event_id"], name: "index_streams_on_event_id"
  end

  create_table "tenants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "color_theme_id"
    t.integer "max_users", default: 50
    t.integer "max_streams", default: 1
    t.integer "max_stream_hours", default: 1
    t.index ["color_theme_id"], name: "index_tenants_on_color_theme_id"
  end

  create_table "themes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active", default: false, null: false
    t.bigint "camp_location_id"
    t.bigint "tenant_id"
    t.index ["active"], name: "index_themes_on_active"
    t.index ["camp_location_id"], name: "index_themes_on_camp_location_id"
    t.index ["tenant_id"], name: "index_themes_on_tenant_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "date_of_birth"
    t.string "gender"
    t.string "type"
    t.string "avatar"
    t.string "chat_uid"
    t.string "chat_auth_token"
    t.string "role"
    t.bigint "camp_location_id"
    t.bigint "device_token_id"
    t.boolean "live_event_notification", default: true
    t.string "time_zone", default: "UTC"
    t.bigint "authentication_id"
    t.bigint "tenant_id"
    t.datetime "last_active_at"
    t.index ["authentication_id"], name: "index_users_on_authentication_id"
    t.index ["camp_location_id"], name: "index_users_on_camp_location_id"
    t.index ["chat_uid"], name: "index_users_on_chat_uid"
    t.index ["device_token_id"], name: "index_users_on_device_token_id"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "welcome_videos", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tenant_id"
    t.index ["tenant_id"], name: "index_welcome_videos_on_tenant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "custom_labels", "tenants"
end
