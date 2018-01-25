require 'date'
require 'sinatra/activerecord'

require_relative '../facebookBot/display_vaccination_dates'
require './models/default_vaccine_schedule'
require './models/vaccination_schedule'

class FetchVaccinationDetails
	VACCINE_COLUMNS_INDEX_STARTS_AT = 10
	def upcoming(id)
		 columns = VaccinationSchedule.column_names
		 # puts columns	 
		 today = Date.today
		 upcoming_vaccine = []
		 for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
			user = VaccinationSchedule.select("#{columns[i]}").where("#{columns[i]} > ? AND parent_facebook_userid = ?",today,id).to_a
			default_record = DefaultVaccineSchedule.where("vaccine_name = ?",columns[i])
			if user.any? then
				# puts columns[i]
				new_vaccine_date = user[0]["#{columns[i]}"]
				vaccine_url 	 = default_record[0]["url"]
				# puts new_vaccine_date
				new_vaccine ={
					"vaccine": "#{columns[i]}",
					"date": "#{new_vaccine_date}",
					"url": "#{vaccine_url}"
				}
				upcoming_vaccine << new_vaccine
			end
		end
		puts upcoming_vaccine
		MessengerBot.new.display_vaccination_dates(id,upcoming_vaccine)
	end

	def previous(id)
		columns = VaccinationSchedule.column_names
		# puts columns	 
		today = Date.today
		previous_vaccine = []
		for i in VACCINE_COLUMNS_INDEX_STARTS_AT..columns.length-1 
			user = VaccinationSchedule.select("#{columns[i]}").where("#{columns[i]} < ? AND parent_facebook_userid = ?",today,id).to_a
			default_record = DefaultVaccineSchedule.where("vaccine_name = ?",columns[i])
			if user.any? then
				# puts columns[i]
				new_vaccine_date = user[0]["#{columns[i]}"]
				vaccine_url 	 = default_record[0]["url"]
				# puts new_vaccine_date
				new_vaccine ={
					"vaccine": "#{columns[i]}",
					"date": "#{new_vaccine_date}",
					"url": "#{vaccine_url}"
				}
				previous_vaccine.insert(0,new_vaccine)
			end
		end
		puts previous_vaccine
		MessengerBot.new.display_vaccination_dates(id,previous_vaccine)
	end

end
