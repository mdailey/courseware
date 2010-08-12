# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100812075206) do

  create_table "announcements", :force => true do |t|
    t.integer  "course_id"
    t.date     "date"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignment_files", :force => true do |t|
    t.integer  "assignment_id"
    t.binary   "file_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer  "course_id"
    t.integer  "number"
    t.string   "title"
    t.string   "ps_flabel"
    t.string   "ps_fname"
    t.string   "soln_flabel"
    t.string   "soln_fname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blurbs", :force => true do |t|
    t.integer  "course_id"
    t.string   "course_page"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_instructors", :force => true do |t|
    t.integer  "course_id"
    t.integer  "person_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_readings", :force => true do |t|
    t.integer  "course_id"
    t.integer  "reading_id"
    t.boolean  "required"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "course_resources", :force => true do |t|
    t.integer  "course_id"
    t.integer  "resource_group_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "rooms"
    t.string   "days_times"
    t.text     "description"
    t.integer  "year"
    t.string   "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exams", :force => true do |t|
    t.integer  "course_id"
    t.integer  "number"
    t.string   "title"
    t.string   "place"
    t.string   "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "handout_files", :force => true do |t|
    t.integer  "handout_id"
    t.binary   "file_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "handouts", :force => true do |t|
    t.integer  "course_id"
    t.integer  "number"
    t.string   "topic"
    t.string   "file_label"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lecture_dates", :force => true do |t|
    t.integer  "lecture_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lecture_note_files", :force => true do |t|
    t.integer  "lecture_note_id"
    t.binary   "file_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lecture_notes", :force => true do |t|
    t.integer  "course_id"
    t.integer  "number"
    t.string   "topic"
    t.string   "file_label"
    t.string   "file_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lectures", :force => true do |t|
    t.integer  "course_id"
    t.integer  "number"
    t.text     "topics"
    t.text     "readings"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_actions", :force => true do |t|
    t.integer  "course_id"
    t.integer  "order"
    t.string   "tag"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "path"
  end

  create_table "people", :force => true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "readings", :force => true do |t|
    t.string   "title"
    t.string   "authors"
    t.string   "image_url"
    t.string   "sales_info_url"
    t.string   "edition"
    t.string   "publisher"
    t.integer  "year"
    t.string   "isbn"
    t.string   "note"
    t.string   "bib_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_groups", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.integer  "resource_group_id"
    t.text     "link"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
