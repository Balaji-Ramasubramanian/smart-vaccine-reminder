require './app'
require 'rake'
require 'sinatra/activerecord/rake'
require 'sinatra/activerecord'
require 'httparty'
require 'json'
require 'date'

require_relative './facebookBot/json_templates/template.rb'
require_relative "./facebookBot/bot.rb"
require_relative "./models/vaccination_schedule.rb"


#Cronjob to notify the users about their kid vaccination:
task :remainder_display do
	VACCINE_COLUMNS_INDEX_STARTS_AT =10
	today = Date.today
	columns = VaccinationSchedule.column_names
	for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
	 	users = VaccinationSchedule.select("parent_facebook_userid,parent_first_name,kid_name,#{columns[i]}").where("#{columns[i]} = ? AND subs = ?",today, true).to_a
	 	if users.any? then
		 	users.each do |u|
		 		MessengerBot.say("#{u["parent_facebook_userid"]}","Hi #{u["parent_first_name"]}, You need to provide #{columns[i].upcase} to your kid #{u["kid_name"]} Today!.")
		 	end
		end

		users = VaccinationSchedule.select("parent_facebook_userid,parent_first_name,kid_name,#{columns[i]}").where("#{columns[i]} = ? AND subs = ?",today+1,true).to_a
	 	if users.any? then
		 	users.each do |u|
		 		MessengerBot.say("#{u["parent_facebook_userid"]}", "Hi #{u["parent_first_name"]}, You need to provide #{columns[i].upcase} to your kid #{u["kid_name"]} Tomorrow!.")
		 	end
		end

		users = VaccinationSchedule.select("parent_facebook_userid,parent_first_name,kid_name,#{columns[i]}").where("#{columns[i]} = ? AND subs = ?",today+3, true).to_a
	 	if users.any? then
		 	users.each do |u|
		 		MessengerBot.say("#{u["parent_facebook_userid"]}" ,"Hi #{u["parent_first_name"]}, You need to provide #{columns[i].upcase} to your kid #{u["kid_name"]} on #{u["#{columns[i]}"]}!.")
		 	end
		end

	end

end