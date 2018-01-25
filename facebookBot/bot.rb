require 'facebook/messenger'
require 'httparty'
require 'json'
require 'date'

require './models/default_vaccine_schedule'
require './models/vaccination_schedule'
require_relative '../utils.rb'
require_relative '../database_editors/vaccination_schedule_editor'
require_relative '../database_editors/fetch_vaccination_details'
require_relative '../database_editors/profile_editor'
require_relative 'json_templates/greeting.rb'
require_relative 'json_templates/persistent_menu.rb'
require_relative 'json_templates/get_started.rb'
require_relative 'json_templates/template.rb'
require_relative 'json_templates/quick_replies.rb'
require_relative '../subscription/subs.rb'
# require_relative '../wit/get_wit_message.rb'
include Facebook::Messenger

class MessengerBot


	def self.get_profile(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		@first_name = profile_details["first_name"]
 		@last_name = profile_details["last_name"]
 		@profile_pic = profile_details["profile_pic"]
 		@locale = profile_details["locale"]
 		@gender = profile_details["gender"]
 		return profile_details
 	end


	def self.say(recipient_id, text)
	  message_options = {
	  messaging_type: "RESPONSE",
	  recipient: { id: recipient_id },
	  message: { text: text }
	  }
	  HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)
	end


	def self.send_quick_reply(id)
		message_options = { messaging_type: "RESPONSE",
							recipient: { id: id},
							message: { text: "Choose a Topic!",
							quick_replies: QUICK_REPLIES 
									}
							}
	 	response = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)
	 end

	def self.typing_on(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			sender_action: "typing_on",
		}
		response = HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)
  		
  	end

  	def self.initial_config(id)
		say(id,"Tell me your your kid name")
		Bot.on :message do |message|
			kid_name = message.text
			puts "Your kid name is #{kid_name}"
			get_dob(id,kid_name)
		end
	end

	def self.get_dob(id,kid_name)
		say(id,"What is #{kid_name}'s date of birth?")
		Bot.on :message do |message|
			kid_dob = message.text
			begin
				dob = Date.parse kid_dob
			rescue ArgumentError
				say(id,"Invalid Date , try DD-MM-YYYY format")
				get_dob(id,kid_name)
			end
			if dob !=nil then
				say(id,"Got it, #{dob} right?")
				get_gender(id,kid_name,dob)
			end
		end
	end

	def self.get_gender(id,kid_name,kid_dob)
		say(id,"Boy or girl child?")
		Bot.on :message do |message|
			if((message.text).downcase == "boy" || (message.text).downcase == "male" ) then
				kid_gender = "male"
			elsif ((message.text).downcase == "girl" || (message.text).downcase == "female") then
				kid_gender = "female"
			else
				say(id,"Please provide a valid gender!")
				get_gender(id,kid_name,kid_dob)
			end

			if kid_gender !=nil then
				puts "#{kid_gender}"
				VaccinationScheduleEditor.new.add_new_kid(id,kid_name,kid_gender,kid_dob)
				say(id,"Thanks for registering your kid details. We will notify you before the vaccination days.")
			end
		end
	end

	def self.edit_kid_name(id)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		say(id,"Tell me your Kid Name")
		Bot.on :message do |message|
			user.update_attributes(:kid_name => message.text)
			say(id,"Done, We updated your Kid Name!")
		end
	end

	def self.edit_kid_gender(id)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		say(id,"Male or Female kid?")
		Bot.on :message do |message|
			if((message.text).downcase == "boy" || (message.text).downcase == "male" ) then
				kid_gender = "male"
			elsif ((message.text).downcase == "girl" || (message.text).downcase == "female") then
				kid_gender = "female"
			else
				say(id,"Please provide a valid gender!")
				edit_kid_gender(id,)
			end

			if kid_gender !=nil then
				user.update_attributes(:kid_gender => kid_gender)
				say(id,"Done, We edited your Kid Gender!")
			end
		end
	end

	def self.edit_kid_dob(id)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		say(id,"What is #{user.kid_name}'s date of birth?")
		Bot.on :message do |message|
			kid_dob = message.text
			begin
				dob = Date.parse kid_dob
			rescue ArgumentError
				say(id,"Invalid Date , try DD-MM-YYYY format")
				edit_kid_dob(id)
			end
			if dob !=nil then
				say(id,"Got it, #{dob} right?")
				user.update_attributes(:kid_dob => kid_dob)
				VaccinationScheduleEditor.new.update_kid_record(id,dob)
				say(id,"Done, We edited your Kid Date Of Birth!")
			end
		end
	end


	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["ACCESS_TOKEN"])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: PERSISTENT_MENU.to_json)

	Bot.on :message do |message|
		puts "inside bot.on message"
		id = message.sender["id"]
		get_profile(id)
		call_message(id,message.text)
	end


	Bot.on :postback do |postback|
		id = postback.sender["id"]
		puts "inside postback bot.on"
		call_postback(id,postback.payload)
	end


	def self.call_message(id,message_text)
		typing_on(id)
		case message_text.downcase
		when "upcoming"
			puts "UPCOMING_VACCINATIONS"
			FetchVaccinationDetails.new.upcoming(id)
		when "previous"
			puts "Previous vaccinations"
			FetchVaccinationDetails.new.previous(id)
		when "profile"
			puts "inside profile message"
			ProfileEditor.new.get_parent_profile(id)
		when "edit kid name"
			MessengerBot.edit_kid_name(id)
		when "edit kid dob"
			MessengerBot.edit_kid_dob(id)
		when "edit kid gender"
			MessengerBot.edit_kid_gender(id)
		else
			say(id,"sorry ")
		end
	end


	def self.call_postback(id,postback_payload)
		typing_on(id)
		case postback_payload
		when "GET_STARTED"
			get_profile(id)
			say(id,"Hey #{@first_name} #{@last_name}! Glad to have you on board. I will keep reminding you about the vaccination days for your kids.")
			initial_config(id)
		when "UPCOMING_VACCINATIONS"
			FetchVaccinationDetails.new.upcoming(id)
		when "PREVIOUS_VACCATIONS"
			FetchVaccinationDetails.new.previous(id)
		when "PROFILE"
			ProfileEditor.new.get_parent_profile(id)
		when "SUBSCRIPTION"
			SubscriptionClass.new.subscriptions(id)
		when "SUBSCRIBE"
			SubscriptionClass.new.subscribe(id)
		when "UNSUBSCRIBE"
			SubscriptionClass.new.unsubscribe(id)
		when "EDIT_KID_NAME"
			MessengerBot.edit_kid_name(id)
		when "EDIT_KID_GENDER"
			MessengerBot.edit_kid_gender(id)
		when "EDIT_KID_DOB"
			MessengerBot.edit_kid_dob(id)
		when "HI"
			say(id,"Hi #{@first_name} #{@last_name} glad to see you!")
			send_quick_reply(id)
		else
			say(id, "sorry")
			send_quick_reply(id)
		end
	end



end

