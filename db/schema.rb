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

ActiveRecord::Schema.define(version: 2018_09_21_132936) do

  create_table "tomatoes", force: :cascade do |t|
    t.string "name"
    t.float "height", default: 0.0, null: false
    t.float "depth", default: 0.0, null: false
    t.float "plant_health", default: 100.0, null: false
    t.float "root_health", default: 100.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turns", force: :cascade do |t|
    t.integer "tomato_id"
    t.float "nitrogen", default: 0.0
    t.float "phosphorus", default: 0.0
    t.float "potassium", default: 0.0
    t.float "water", default: 0.0
    t.float "accum_nitrogen", default: 0.0
    t.float "accum_phosphorus", default: 0.0
    t.float "accum_potassium", default: 0.0
    t.float "accum_water", default: 0.0
    t.float "light", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tomato_id"], name: "index_turns_on_tomato_id"
  end

end
