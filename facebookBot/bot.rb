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
require_relative '../database_editors/vaccine_details'
require_relative '../subscription/subscription.rb'
require_relative '../wit/get_wit_message'
require_relative 'json_templates/greeting.rb'
require_relative 'json_templates/persistent_menu.rb'
require_relative 'json_templates/get_started.rb'
require_relative 'json_templates/template.rb'
require_relative 'json_templates/quick_replies.rb'
include Facebook::Messenger

class MessengerBot

	#Method to get user Facebook profile details
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

 	#Method to push a message to Facebook
	def self.say(recipient_id, text)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: recipient_id },
			message: { text: text }
		}
		HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)
	end

	#To send a quick reply to user
	def self.send_quick_reply(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id},
			message: {
				text: "How can I help you?",
				quick_replies: QUICK_REPLIES 
			}
		}
	 	response = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options.to_json)

	 	Bot.on :message do |message|
			id = message.sender["id"]
			call_message(id,message.text)
		end

		Bot.on :postback do |postback|
			id = postback.sender["id"]
			call_postback(id,postback.payload)
		end
	 end

	#Typing indication:
	def self.typing_on(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			sender_action: "typing_on",
		}
		response = HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)		
  	end

  	#Initial configuration method to get kid name 
  	def self.initial_config(id)
		say(id,"Tell me your your kid name")
		Bot.on :message do |message|
			kid_name = message.text
			get_dob(id,kid_name)
		end
	end

	#Initial configuration method to get kid Date of birth
	def self.get_dob(id,kid_name)
		say(id,"What is #{kid_name}'s date of birth?")
		Bot.on :message do |message|
			kid_dob = message.text
			begin
				dob = Date.parse kid_dob
			rescue ArgumentError
				say(id,"Invalid Date , provide it in DD-MM-YYYY format")
				get_dob(id,kid_name)
			end
			if dob !=nil then
				date_full_format = dob.strftime("%d %b %Y")
				say(id,"Got it, #{date_full_format}")
				get_gender(id,kid_name,dob)
			end
		end
	end

	#Initial configuration method to get kid Gender
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
				VaccinationScheduleEditor.new.add_new_kid(id,kid_name,kid_gender,kid_dob)
				say(id,"Thanks for registering your kid details. We will notify you before the vaccination days.")
				send_quick_reply(id)
			end
		end
	end

	#Method to edit kid name in the database
	def self.edit_kid_name(id,kid_name =nil)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if kid_name == nil then
			say(id,"Tell me your Kid Name")
			Bot.on :message do |message|
				user.update_attributes(:kid_name => message.text)
				say(id,"Done, We have updated your Kid Name as #{message.text}!")
				send_quick_reply(id)
			end
		else
			user.update_attributes(:kid_name => kid_name)
			say(id,"Done, We have updated your Kid Name as #{kid_name}!")
			send_quick_reply(id)
		end

	end

	#Method to edit kid gender in the database
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
				say(id,"Done, We have updated your kid gender details!")
				send_quick_reply(id)
			end
		end
	end

	#Method to edit kid date of birth in the database
	def self.edit_kid_dob(id,dob_val = nil)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if dob_val == nil then
			say(id,"What is #{user.kid_name}'s date of birth?")
			Bot.on :message do |message|
				kid_dob = message.text
				validate_dob(id,kid_dob)
			end
		else
			validate_dob(id,dob_val)
		end

	end

	#Method to validate kid date of birth
	def self.validate_dob(id,kid_dob)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		begin
			dob = Date.parse kid_dob
		rescue ArgumentError
			say(id,"Invalid Date , provide it in DD-MM-YYYY format")
			edit_kid_dob(id)
		end
		if dob !=nil then
			date_full_format = dob.strftime("%d %b %Y")
			say(id,"Got it, #{date_full_format}")
			user.update_attributes(:kid_dob => kid_dob)
			VaccinationScheduleEditor.new.update_kid_record(id,dob)
			say(id,"Done, We have updated your Kid Date Of Birth!")
			send_quick_reply(id)
		end	
	end

	#Method used to retrive the user profile when rejoin to the bot
	def old_user(id)
		MessengerBot.say(id,"You can edit your previous records, or continue with the same")
		ProfileEditor.new.get_parent_profile(id)
		MessengerBot.send_quick_reply(id)
	end

	#Initial configuration for the bot 
	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: PERSISTENT_MENU.to_json)

	#Triggers whenever a message has got
	Bot.on :message do |message|
		id = message.sender["id"]
		call_message(id,message.text)
	end

	#Triggers whenever a postback happens
	Bot.on :postback do |postback|
		id = postback.sender["id"]
		call_postback(id,postback.payload)
	end

	#Method to handle bot messages
	def self.call_message(id,message_text)
		typing_on(id)
		get_profile(id)
		case message_text.downcase
		when "hi"
			say(id,"Hi #{@first_name} #{@last_name} glad to see you!")
			send_quick_reply(id)
		when "upcoming vaccines"
			FetchVaccinationDetails.new.upcoming(id)
		when "previous vaccines"
			FetchVaccinationDetails.new.previous(id)
		when "profile"
			ProfileEditor.new.get_parent_profile(id)
		when "edit kid name"
			MessengerBot.edit_kid_name(id)
		when "edit kid dob"
			MessengerBot.edit_kid_dob(id)
		when "edit kid gender"
			MessengerBot.edit_kid_gender(id)
		else
			handle_wit_response(id,message_text)
		end
	end

	#Method to handle wit response
	def self.handle_wit_response(id,message_text)
		wit_response =  Wit.new.get_intent(message_text)
		if wit_response.class == String
			MessengerBot.call_postback(id,wit_response)
		else
			if wit_response["gender_value"] != nil then
				user = VaccinationSchedule.find_by_parent_facebook_userid(id)
				if wit_response["gender_value"][0]["value"] == "MALE" then
					user.update_attributes(:kid_gender => "male")
					say(id,"Done, We have edited your Kid Gender!")
					send_quick_reply(id)
				elsif wit_response["gender_value"][0]["value"] == "FEMALE" then
					user.update_attributes(:kid_gender => "female")
					say(id,"Done, We have edited your Kid Gender!")
					send_quick_reply(id)
				else
					MessengerBot.call_postback(id,wit_response["intent"][0]["value"])
				end
			end

			if wit_response["dob_value"] !=nil then
				user = VaccinationSchedule.find_by_parent_facebook_userid(id)
				edit_kid_dob(id,wit_response["dob_value"][0]["value"])
			end

			if wit_response["name_value"] != nil then
				user = VaccinationSchedule.find_by_parent_facebook_userid(id)
				edit_kid_name(id,wit_response["name_value"][0]["value"])
			end

			if wit_response["vaccine"] !=nil then
				VaccineDetails.new.get_vaccine_details(id,wit_response["vaccine"][0]["value"])
			end
		end

	end

	#Method to handle postbacks
	def self.call_postback(id,postback_payload)
		typing_on(id)
		case postback_payload
		when "GET_STARTED"
			get_profile(id)
			say(id,"Hey #{@first_name} #{@last_name}! Glad to have you on board. I will keep reminding you about the vaccination days for your kids.")
			user = VaccinationSchedule.find_by_parent_facebook_userid(id)
			if user == nil then
				initial_config(id) 
			else
				MessengerBot.new.old_user(id)
			end
		when "UPCOMING_VACCINATIONS"
			FetchVaccinationDetails.new.upcoming(id)
		when "PREVIOUS_VACCINATIONS"
			FetchVaccinationDetails.new.previous(id)
		when "PROFILE"
			ProfileEditor.new.get_parent_profile(id)
		when "SUBSCRIPTION"
			SubscriptionClass.new.subscriptions(id)
		when "SUBSCRIBE"
			SubscriptionClass.new.subscribe(id)
		when "UNSUBSCRIBE"
			SubscriptionClass.new.unsubscribe(id)
		when "WHY_SUBSCRIBE"
			say(id,"I will remind you about the vaccination days for your kid on the appropriate dates.")
		when "EDIT_KID_NAME"
			MessengerBot.edit_kid_name(id)
		when "EDIT_KID_GENDER"
			MessengerBot.edit_kid_gender(id)
		when "EDIT_KID_DOB"
			MessengerBot.edit_kid_dob(id)
		when "HI"
			say(id,"Hi #{@first_name} #{@last_name} Glad to see you!")
			send_quick_reply(id)
		else
			say(id, "Sorry I couldn't understand that.. 🙁")
			say(id, "Try these simple commands,\n*Show my upcoming vaccines\n*what are my past vaccines?\n*change my kid name\n*show my profile")
		end
	end
end