require 'date'
require 'sinatra/activerecord'

require_relative '../facebookBot/display_vaccination_dates'
require_relative '../facebookBot/bot.rb'
require_relative '../facebookBot/display_profile'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'

class ProfileEditor

	#Method to fetch User profile from database
	def get_parent_profile(id)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if user != nil then
			parent_first_name = user.parent_first_name
			parent_last_name = user.parent_last_name
			kid_name = user.kid_name
			kid_dob = user.kid_dob
			kid_gender = user.kid_gender
			MessengerBot.new.display_profile(id,parent_first_name,parent_last_name,kid_name,kid_dob,kid_gender)
		else
			MessengerBot.say(id,"Please Register your details first!")
			MessengerBot.initial_config(id)
		end
		Bot.on :message do |message|
			puts "inside ProfileEditor"
			id = message.sender["id"]
			MessengerBot.call_message(id,message.text)
		end


		Bot.on :postback do |postback|
			id = postback.sender["id"]
			MessengerBot.call_postback(id,postback.payload)
		end
	end

end