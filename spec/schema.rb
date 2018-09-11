ActiveRecord::Schema.define do
  self.verbose = false
  
  create_table "universities", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_universities_on_code"
    t.index ["name"], name: "index_universities_on_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "username"
    t.string "contact_no"
    t.boolean "super", default: false
    t.integer "status", default: 0
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["status"], name: "index_users_on_status"
    t.index ["super"], name: "index_users_on_super"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "university_id"
    t.bigint "user_id"
    t.bigint "course_id"
    t.string "type"
    t.integer "status", default: 0
    t.date "start_date"
    t.date "end_date"
    t.string "created_by"
    t.string "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["course_id"], name: "index_members_on_course_id"
    t.index ["university_id"], name: "index_members_on_university_id"
    t.index ["status"], name: "index_members_on_status"
    t.index ["type"], name: "index_members_on_type"
    t.index ["user_id"], name: "index_members_on_user_id"
  end
end