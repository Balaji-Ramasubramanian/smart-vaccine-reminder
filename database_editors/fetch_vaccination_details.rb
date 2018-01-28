require 'date'
require 'sinatra/activerecord'
require 'facebook/messenger'

require_relative '../facebookBot/display_vaccination_dates'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'

class FetchVaccinationDetails
	VACCINE_COLUMNS_INDEX_STARTS_AT = 10

	#Method to fetch upcoming vaccination days from database
	def upcoming(id)
		columns = VaccinationSchedule.column_names 
		today = Date.today
		upcoming_vaccine = []
		for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
			user = VaccinationSchedule.select("#{columns[i]}").where("#{columns[i]} > ? AND parent_facebook_userid = ?",today,id).to_a
			default_record = DefaultVaccineSchedule.where("vaccine_name = ?",columns[i])
			if user.any? then
				new_vaccine_date = user[0]["#{columns[i]}"]
				vaccine_url 	 = default_record[0]["url"]
				new_vaccine ={
					"vaccine": "#{columns[i]}",
					"date": "#{new_vaccine_date}",
					"url": "#{vaccine_url}"
				}
				upcoming_vaccine << new_vaccine
			end
		end
		MessengerBot.say(id,"Here are the list of upcoming vaccines for your kid")
		MessengerBot.new.display_vaccination_dates(id,upcoming_vaccine)

		Bot.on :message do |message|
			id = message.sender["id"]
			MessengerBot.call_message(id,message.text)
		end

		Bot.on :postback do |postback|
			id = postback.sender["id"]
			MessengerBot.call_postback(id,postback.payload)
		end
	end

	#Method to fetch past vaccination dates from database
	def previous(id)
		columns = VaccinationSchedule.column_names 
		today = Date.today
		previous_vaccine = []
		for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
			user = VaccinationSchedule.select("#{columns[i]}").where("#{columns[i]} < ? AND parent_facebook_userid = ?",today,id).to_a
			default_record = DefaultVaccineSchedule.where("vaccine_name = ?",columns[i])
			if user.any? then
				new_vaccine_date = user[0]["#{columns[i]}"]
				vaccine_url 	 = default_record[0]["url"]
				new_vaccine ={
					"vaccine": "#{columns[i]}",
					"date": "#{new_vaccine_date}",
					"url": "#{vaccine_url}"
				}
				previous_vaccine.insert(0,new_vaccine)
			end
		end
		MessengerBot.say(id,"Here are the list of provided vaccines for your kid")
		MessengerBot.new.display_vaccination_dates(id,previous_vaccine)

		Bot.on :message do |message|
			id = message.sender["id"]
			MessengerBot.call_message(id,message.text)
		end

		Bot.on :postback do |postback|
			id = postback.sender["id"]
			MessengerBot.call_postback(id,postback.payload)
		end
	end
		
end
