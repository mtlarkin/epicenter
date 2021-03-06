# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170609202430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendance_records", force: :cascade do |t|
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "tardy"
    t.date     "date"
    t.boolean  "left_early"
    t.datetime "signed_out_time"
    t.integer  "pair_id"
    t.string   "station"
    t.boolean  "ignore"
  end

  add_index "attendance_records", ["created_at"], name: "index_attendance_records_on_created_at", using: :btree
  add_index "attendance_records", ["student_id"], name: "index_attendance_records_on_student_id", using: :btree
  add_index "attendance_records", ["tardy"], name: "index_attendance_records_on_tardy", using: :btree

  create_table "code_reviews", force: :cascade do |t|
    t.string   "title",                    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "number"
    t.boolean  "submissions_not_required"
    t.text     "content"
    t.date     "date"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string  "description"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "office_id"
    t.integer "track_id"
  end

  add_index "cohorts", ["office_id"], name: "index_cohorts_on_office_id", using: :btree
  add_index "cohorts", ["track_id"], name: "index_cohorts_on_track_id", using: :btree

  create_table "course_internships", force: :cascade do |t|
    t.integer "course_id"
    t.integer "internship_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string   "description",       limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "class_days"
    t.string   "start_time"
    t.string   "end_time"
    t.integer  "admin_id"
    t.boolean  "internship_course"
    t.boolean  "active"
    t.integer  "office_id"
    t.boolean  "rankings_visible"
    t.boolean  "parttime",                      default: false
    t.integer  "language_id"
    t.string   "end_time_friday"
    t.integer  "cohort_id"
    t.integer  "track_id"
  end

  add_index "courses", ["cohort_id"], name: "index_courses_on_cohort_id", using: :btree
  add_index "courses", ["start_date"], name: "index_courses_on_start_date", using: :btree
  add_index "courses", ["track_id"], name: "index_courses_on_track_id", using: :btree

  create_table "enrollments", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

  add_index "enrollments", ["deleted_at"], name: "index_enrollments_on_deleted_at", using: :btree

  create_table "grades", force: :cascade do |t|
    t.integer  "objective_id"
    t.integer  "score_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_id"
  end

  create_table "internship_assignments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "internship_id"
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "internship_tracks", force: :cascade do |t|
    t.integer "internship_id"
    t.integer "track_id"
  end

  create_table "internships", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "old_course_id"
    t.text     "description"
    t.text     "ideal_intern"
    t.boolean  "clearance_required"
    t.text     "clearance_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "website"
    t.string   "address"
    t.integer  "number_of_students"
    t.string   "interview_location"
    t.boolean  "remote"
  end

  create_table "interview_assignments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "internship_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ranking_from_company"
    t.text     "feedback_from_company"
    t.integer  "course_id"
    t.integer  "ranking_from_student"
    t.text     "feedback_from_student"
  end

  create_table "languages", force: :cascade do |t|
    t.string  "name"
    t.integer "level"
  end

  create_table "languages_tracks", id: false, force: :cascade do |t|
    t.integer "track_id",    null: false
    t.integer "language_id", null: false
  end

  create_table "objectives", force: :cascade do |t|
    t.string   "content",        limit: 255
    t.integer  "code_review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "offices", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "account_uri",      limit: 255
    t.string   "verification_uri", limit: 255
    t.integer  "student_id"
    t.boolean  "verified"
    t.string   "last_four_string", limit: 255
    t.string   "type",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stripe_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "payment_uri",         limit: 255
    t.integer  "student_id"
    t.integer  "fee",                             default: 0, null: false
    t.integer  "payment_method_id"
    t.string   "status",              limit: 255
    t.string   "stripe_transaction"
    t.integer  "refund_amount"
    t.boolean  "offline"
    t.text     "notes"
    t.string   "description"
    t.boolean  "refund_issued"
    t.boolean  "failure_notice_sent"
  end

  add_index "payments", ["student_id"], name: "index_payments_on_student_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "upfront_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "close_io_description"
    t.boolean  "archived"
    t.boolean  "loan"
    t.boolean  "standard"
    t.integer  "first_day_amount"
    t.date     "start_date"
    t.boolean  "parttime"
    t.boolean  "upfront"
    t.string   "description"
  end

  create_table "questions", force: :cascade do |t|
    t.integer :id
    t.string "course"
    t.integer "week"
    t.integer "day"
    t.string "topic"
    t.string "question"
    t.string "correct_answer"
    t.string "incorrect_answer_one"
    t.string "incorrect_answer_two"
    t.string "incorrect_answer_three"
    t.integer "times_answered_correctly"
    t.integer "times_answered_incorrectly"
    t.string "lesson_link"
  end

  create_table "quizzes", force: :cascade do |t|
    t.integer :id
    t.string "course"
    t.integer "week"
    t.integer "day"
    t.integer "question_1_id"
    t.integer "question_2_id"
    t.integer "question_3_id"
    t.integer "question_4_id"
    t.integer "question_5_id"
    t.integer "question_6_id"
    t.integer "question_7_id"
    t.integer "question_8_id"
    t.integer "question_9_id"
    t.integer "question_10_id"
    t.integer "question_11_id"
    t.integer "question_12_id"
    t.integer "question_13_id"
    t.integer "question_14_id"
    t.integer "question_15_id"
    t.integer "question_16_id"
    t.integer "question_17_id"
    t.integer "question_18_id"
    t.integer "question_19_id"
    t.integer "question_20_id"
  end

  create_table "students_quizzes", force: :cascade do |t|
    t.integer "student_id"
    t.integer "quiz_id"
    t.integer "correct"
    t.integer "incorrect"
    t.integer "score"
  end




  create_table "ratings", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "internship_id"
    t.string   "interest"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "submission_id"
    t.integer  "admin_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "student_signature"
  end

  create_table "scores", force: :cascade do |t|
    t.integer  "value"
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "signature_id"
    t.string   "type"
    t.boolean  "is_complete"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "signature_request_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "student_id"
    t.text     "link"
    t.integer  "code_review_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "needs_review"
    t.integer  "times_submitted"
    t.string   "blurb"
  end

  add_index "submissions", ["code_review_id"], name: "index_submissions_on_code_review_id", using: :btree
  add_index "submissions", ["student_id"], name: "index_submissions_on_student_id", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                     limit: 255, default: "", null: false
    t.string   "encrypted_password",        limit: 255, default: ""
    t.string   "reset_password_token",      limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",        limit: 255
    t.string   "last_sign_in_ip",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                      limit: 255
    t.integer  "plan_id"
    t.integer  "old_course_id"
    t.integer  "primary_payment_method_id"
    t.string   "type",                      limit: 255
    t.integer  "current_course_id"
    t.string   "invitation_token",          limit: 255
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type",           limit: 255
    t.integer  "invitations_count",                     default: 0
    t.string   "stripe_customer_id"
    t.string   "github_uid"
    t.boolean  "referral_email_sent"
    t.integer  "failed_attempts",                       default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "deleted_at"
    t.boolean  "demographics"
    t.integer  "attendance_warnings_sent"
    t.integer  "solo_warnings_sent"
    t.integer  "starting_cohort_id"
    t.boolean  "teacher"
  end

  add_index "users", ["deleted_at"], name: "index_users_on_deleted_at", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["plan_id"], name: "index_users_on_plan_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "cohorts", "offices"
  add_foreign_key "cohorts", "tracks"
  add_foreign_key "courses", "cohorts"
  add_foreign_key "courses", "tracks"
end
