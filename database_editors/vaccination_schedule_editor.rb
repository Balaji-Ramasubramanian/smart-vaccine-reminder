 require 'date'
require 'sinatra/activerecord'

require './models/default_vaccine_schedule'
require './models/vaccination_schedule'
require_relative '../facebookBot/bot'
require_relative '../utils'

class VaccinationScheduleEditor
	  VACCINE_COLUMNS_INDEX_STARTS_AT = 10

	#Method to get user Facebook profile details
	def get_profile(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		@first_name = profile_details["first_name"]
 		@last_name = profile_details["last_name"]
 		@profile_pic = profile_details["profile_pic"]
 		@locale = profile_details["locale"]
 		@gender = profile_details["gender"]
 	end

 	#Method to fill details of kid
	def add_new_kid(id,kid_name,kid_gender,kid_dob)
		#To get the details from facebook
		get_profile(id)
		@language = @locale[0,2]
		#create database instance
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
    	if (user == nil) then
			t = VaccinationSchedule.new
			# update table columns with facebook profile details
			t.parent_facebook_userid =id
			t.parent_first_name =@first_name
			t.parent_last_name	=@last_name
			t.parent_gender	=@gender
			t.locale	=@locale
			t.subscription	=true

			# fill the kid's details
			t.kid_name = kid_name
			t.kid_gender = kid_gender
			t.kid_dob = kid_dob
			t.save
			
			# fill the vaccination dates in database
			VaccinationScheduleEditor.new.update_kid_record(id,kid_dob)
		else
			MessengerBot.say(id,ALREADY_SUBSCRIBED_TEXT["#{@language}"])
		end
	end

	#Method to update kid vaccination date records
	def update_kid_record(id,kid_dob)
		
		kid_record = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if kid_record != nil then
			columns = VaccinationSchedule.column_names 
			for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
				d = DefaultVaccineSchedule.find_by_vaccine_name("#{columns[i]}")
				kid_record.update_attributes("#{columns[i]}" => kid_dob + d.due_date)
			end
		else
			MessengerBot.say(id,NOT_REGISTER_TEXT["#{@language}"])
		end

	end

end