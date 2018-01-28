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

ActiveRecord::Schema.define(version: 20180124144830) do

  create_table "default_vaccine_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "vaccine_name"
    t.integer "due_date"
    t.string "url"
  end

  create_table "vaccination_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "parent_facebook_userid"
    t.string "parent_first_name"
    t.string "parent_last_name"
    t.string "parent_gender"
    t.string "locale"
    t.boolean "subs"
    t.string "kid_name"
    t.date "kid_dob"
    t.string "kid_gender"
    t.date "bcg_dose1"
    t.date "hepb_dose1"
    t.date "poliovirus_dose1"
    t.date "hepb_dose2"
    t.date "poliovirus_dose2"
    t.date "dtp_dose1"
    t.date "hib_dose1"
    t.date "pcv_dose1"
    t.date "rv_dose1"
    t.date "poliovirus_dose3"
    t.date "dtp_dose2"
    t.date "hib_dose2"
    t.date "pcv_dose2"
    t.date "rv_dose2"
    t.date "hepb_dose3"
    t.date "dtp_dose3"
    t.date "hib_dose3"
    t.date "pcv_dose3"
    t.date "rv_dose3"
    t.date "typhoid_dose1"
    t.date "mmr_dose1"
    t.date "dtp_dose4"
    t.date "hib_dose4"
    t.date "pcv_dose4"
    t.date "varicella_dose1"
    t.date "hepa_dose1"
    t.date "mmr_dose2"
    t.date "varicella_dose2"
    t.date "hepa_dose2"
    t.date "typhoid_dose2"
    t.date "dtp_dose5"
    t.date "tdap_dose1"
    t.date "hpv_dose1"
    t.date "hpv_dose2"
    t.date "hpv_dose3"
  end

end
