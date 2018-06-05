require 'date'
require 'sinatra/activerecord'
require 'facebook/messenger'

require_relative '../facebookBot/display_vaccination_dates'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'
require_relative './db_strings'
class VaccineDetails

	def get_vaccine_details(id,vaccine_name)
		@language = MessengerBot.new.get_language(id)
		vaccine = DefaultVaccineSchedule.select("*").where("vaccine_name LIKE ?","#{vaccine_name.downcase}%")
		if vaccine.length == 0 
			reply_text = NO_VACCINE_FOUND_TEXT["#{@language}"] + vaccine_name + CHECK_OUT_SPELLING_TEXT["#{@language}"]
			MessengerBot.say(id, reply_text)
		else
			kid = VaccinationSchedule.find_by_parent_facebook_userid(id)
			vaccine_list =[]
			vaccine.each do |v|
				new_vaccine ={
					"vaccine_name": v.vaccine_name,
					"due_date": "#{kid.kid_dob+v.due_date}",
					"url": v.url
				}
				vaccine_list<<new_vaccine
			end
			MessengerBot.new.display_vaccination_dates(id,vaccine_list)
		end
	end

end