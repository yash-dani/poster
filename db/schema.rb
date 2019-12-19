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

ActiveRecord::Schema.define(version: 2019_12_18_022503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "citations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "post_id"
    t.json "body"
    t.text "title"
    t.text "authors"
    t.string "imprint_date"
    t.string "imprint_type"
    t.string "target"
    t.string "publisher"
    t.integer "generated_post_id"
    t.index ["post_id"], name: "index_citations_on_post_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "title"
    t.json "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
    t.string "publisher"
    t.text "authors"
    t.datetime "publish_date"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "upload_images", force: :cascade do |t|
    t.integer "upload_id"
    t.string "type"
    t.integer "width"
    t.integer "height"
    t.string "index"
    t.text "image_data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["upload_id"], name: "index_upload_images_on_upload_id"
  end

  create_table "upload_teis", force: :cascade do |t|
    t.integer "upload_id"
    t.jsonb "body"
    t.jsonb "header"
    t.jsonb "references"
    t.index ["upload_id"], name: "index_upload_teis_on_upload_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "file_data"
    t.integer "post_id"
    t.index ["post_id"], name: "index_uploads_on_post_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.string "first_name"
    t.string "last_name"
    t.boolean "admin"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
