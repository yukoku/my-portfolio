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

ActiveRecord::Schema.define(version: 2019_08_10_184529) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "project_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted_project_invitation", default: false
    t.boolean "has_sent_message", default: false
    t.string "project_invitation_token"
    t.index ["project_id"], name: "index_project_members_on_project_id"
    t.index ["project_invitation_token"], name: "index_project_members_on_project_invitation_token", unique: true
    t.index ["user_id"], name: "index_project_members_on_user_id"
  end

  create_table "project_owners", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_owners_on_project_id"
    t.index ["user_id"], name: "index_project_owners_on_user_id"
  end

  create_table "projects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "due_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ticket_attributes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "ticket_attribute"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_ticket_attributes_on_project_id"
  end

  create_table "ticket_priorities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "priority"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_ticket_priorities_on_project_id"
  end

  create_table "ticket_statuses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status"
    t.bigint "project_id"
    t.index ["project_id"], name: "index_ticket_statuses_on_project_id"
  end

  create_table "tickets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "creator_id"
    t.bigint "assignee_id"
    t.string "title"
    t.text "description"
    t.date "due_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ticket_attribute_id"
    t.bigint "ticket_status_id"
    t.bigint "ticket_priority_id"
    t.index ["assignee_id"], name: "index_tickets_on_assignee_id"
    t.index ["creator_id"], name: "index_tickets_on_creator_id"
    t.index ["project_id"], name: "index_tickets_on_project_id"
    t.index ["ticket_attribute_id"], name: "index_tickets_on_ticket_attribute_id"
    t.index ["ticket_priority_id"], name: "index_tickets_on_ticket_priority_id"
    t.index ["ticket_status_id"], name: "index_tickets_on_ticket_status_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.bigint "invited_by_id"
    t.string "invited_by_type"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "project_members", "projects"
  add_foreign_key "project_members", "users"
  add_foreign_key "project_owners", "projects"
  add_foreign_key "project_owners", "users"
  add_foreign_key "ticket_attributes", "projects"
  add_foreign_key "ticket_priorities", "projects"
  add_foreign_key "ticket_statuses", "projects"
  add_foreign_key "tickets", "projects"
  add_foreign_key "tickets", "ticket_attributes"
  add_foreign_key "tickets", "ticket_priorities"
  add_foreign_key "tickets", "ticket_statuses"
  add_foreign_key "tickets", "users", column: "assignee_id"
  add_foreign_key "tickets", "users", column: "creator_id"
end
