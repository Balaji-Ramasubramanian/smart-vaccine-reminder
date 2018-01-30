require 'date'
require 'sinatra/activerecord'
require 'facebook/messenger'

require_relative '../facebookBot/display_vaccination_dates'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'

class VaccineDetails

	def get_vaccine_details(id,vaccine_name)
		vaccine = DefaultVaccineSchedule.where("vaccine_name LIKE ?",vaccine_name)
		if vaccine == nil
			MessengerBot.say(id,"Sorry, there is no vaccine under the name #{vaccine_name}, please check your spelling!")
		else
			MessengerBot.display_vaccination_dates(id,vaccine)
		end
	end
	
		Bot.on :message do |message|
			id = message.sender["id"]
			MessengerBot.call_message(id,message.text)
		end

		Bot.on :postback do |postback|
			id = postback.sender["id"]
			MessengerBot.call_postback(id,postback.payload)
		end


end