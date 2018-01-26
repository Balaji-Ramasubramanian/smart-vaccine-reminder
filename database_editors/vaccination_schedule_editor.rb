 require 'date'
require 'sinatra/activerecord'

require './models/default_vaccine_schedule'
require './models/vaccination_schedule'
require_relative '../facebookBot/bot'
require_relative '../utils.rb'

class VaccinationScheduleEditor

	def get_profile(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		@first_name = profile_details["first_name"]
 		@last_name = profile_details["last_name"]
 		@profile_pic = profile_details["profile_pic"]
 		@locale = profile_details["locale"]
 		@gender = profile_details["gender"]
 	end

	def add_new_kid(id,kid_name,kid_gender,kid_dob)
		puts "inside add_new_kid method"
	# to get the details from facebook:
		get_profile(id)
	# create database instance:
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
    	if (user == nil) then
    		puts "inside add_new_kid  ->if"
			t = VaccinationSchedule.new
		# update table columns with facebook profile details:
			t.parent_facebook_userid =id
			t.parent_first_name =@first_name
			t.parent_last_name	=@last_name
			t.parent_gender	=@gender
			t.locale	=@locale
			t.subs	=true
		# fill the kid's details
			t.kid_name = kid_name
			t.kid_gender = kid_gender
			t.kid_dob = kid_dob
		# fill the vaccination dates in database:
			d = DefaultVaccineSchedule.find_by_vaccine_name("bcg_dose1")
			t.bcg_dose1 	=("#{kid_dob + d.due_date}")
			
			d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose1")
	  		t.hepb_dose1 	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose2")
	  		t.hepb_dose2 	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose3")
	  		t.hepb_dose3 	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose1")
	  		t.poliovirus_dose1	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose2")
	  		t.poliovirus_dose2	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose3")
	  		t.poliovirus_dose3	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose1")
	  		t.dtp_dose1	=("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose2")
	  		t.dtp_dose2 =("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose3")
	  		t.dtp_dose3 =("#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose4")
	  		t.dtp_dose4 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose5")
	  		t.dtp_dose5 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose1")
	  		t.hib_dose1 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose2")
	  		t.hib_dose2 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose3")
	  		t.hib_dose3 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose4")
	  		t.hib_dose4 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose1")
	  		t.pcv_dose1 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose2")
	  		t.pcv_dose2 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose3")
	  		t.pcv_dose3 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose4")
	  		t.pcv_dose4 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose1")
	  		t.rv_dose1	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose2")
	  		t.rv_dose2	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose3")
	  		t.rv_dose3	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("typhoid_dose1")
	  		t.typhoid_dose1	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("typhoid_dose2")
	  		t.typhoid_dose2 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("mmr_dose1")
	  		t.mmr_dose1	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("mmr_dose2")
	  		t.mmr_dose2 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("varicella_dose1")
	  		t.varicella_dose1 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("varicella_dose2")
	  		t.varicella_dose2 =("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepa_dose1")
	  		t.hepa_dose1	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepa_dose2")
	  		t.hepa_dose2	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("tdap_dose1")
	  		t.tdap_dose1	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose1")
	  		t.hpv_dose1		=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose2")
	  		t.hpv_dose2 	=("#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose3")
	  		t.hpv_dose3 	=("#{kid_dob + d.due_date}")
	  		
			t.save
		else
			MessengerBot.say(id,"You are already subscribed!")
		end
	end


	def update_kid_record(id,kid_dob)
		kid_record = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if kid_record != nil
			d = DefaultVaccineSchedule.find_by_vaccine_name("bcg_dose1")
			kid_record.update_attributes(:bcg_dose1 => "#{kid_dob + d.due_date}")
			
			d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose1")
	  		kid_record.update_attributes(:hepb_dose1 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose2")
	  		kid_record.update_attributes(:hepb_dose2 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepb_dose3")
	  		kid_record.update_attributes(:hepb_dose3 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose1")
	  		kid_record.update_attributes(:poliovirus_dose1 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose2")
	  		kid_record.update_attributes(:poliovirus_dose2 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("poliovirus_dose3")
	  		kid_record.update_attributes(:poliovirus_dose3 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose1")
	  		kid_record.update_attributes(:dtp_dose1 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose2")
	  		kid_record.update_attributes(:dtp_dose2 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose3")
	  		kid_record.update_attributes(:dtp_dose3 =>"#{kid_dob+ d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose4")
	  		kid_record.update_attributes(:dtp_dose4 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("dtp_dose5")
	  		kid_record.update_attributes(:dtp_dose5 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose1")
	  		kid_record.update_attributes(:hib_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose2")
	  		kid_record.update_attributes(:hib_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose3")
	  		kid_record.update_attributes(:hib_dose3 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hib_dose4")
	  		kid_record.update_attributes(:hib_dose4 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose1")
	  		kid_record.update_attributes(:pcv_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose2")
	  		kid_record.update_attributes(:pcv_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose3")
	  		kid_record.update_attributes(:pcv_dose3 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("pcv_dose4")
	  		kid_record.update_attributes(:pcv_dose4 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose1")
	  		kid_record.update_attributes(:rv_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose2")
	  		kid_record.update_attributes(:rv_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("rv_dose3")
	  		kid_record.update_attributes(:rv_dose3 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("typhoid_dose1")
	  		kid_record.update_attributes(:typhoid_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("typhoid_dose2")
	  		kid_record.update_attributes(:typhoid_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("mmr_dose1")
	  		kid_record.update_attributes(:mmr_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("mmr_dose2")
	  		kid_record.update_attributes(:mmr_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("varicella_dose1")
	  		kid_record.update_attributes(:varicella_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("varicella_dose2")
	  		kid_record.update_attributes(:varicella_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepa_dose1")
	  		kid_record.update_attributes(:hepa_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hepa_dose2")
	  		kid_record.update_attributes(:hepa_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("tdap_dose1")
	  		kid_record.update_attributes(:tdap_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose1")
	  		kid_record.update_attributes(:hpv_dose1 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose2")
	  		kid_record.update_attributes(:hpv_dose2 =>"#{kid_dob + d.due_date}")
	  		
	  		d = DefaultVaccineSchedule.find_by_vaccine_name("hpv_dose3")
	  		kid_record.update_attributes(:hpv_dose3 =>"#{kid_dob + d.due_date}")
		end
	end

end