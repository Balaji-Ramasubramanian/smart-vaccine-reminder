require 'facebook/messenger'
require 'httparty'
require 'json'
require 'date'

require './models/default_vaccine_schedule'
require './models/vaccination_schedule'
require_relative '../utils'
require_relative '../database_editors/vaccination_schedule_editor'
require_relative '../database_editors/fetch_vaccination_details'
require_relative '../database_editors/profile_editor'
require_relative '../database_editors/vaccine_details'
require_relative '../subscription/subscription'
require_relative '../wit/get_wit_message'
require_relative 'json_templates/greeting'
require_relative 'json_templates/persistent_menu'
require_relative 'json_templates/get_started'
require_relative 'json_templates/template'
require_relative 'json_templates/quick_replies'
require_relative 'strings'
include Facebook::Messenger

class MessengerBot

	# Method to get user Facebook profile details
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


 	# Returns language of the user
 	def get_language(id)
 		fb_profile_url = FB_PROFILE + id + FB_PROFILE_FIELDS
 		profile_details = HTTParty.get(fb_profile_url)
 		locale = profile_details["locale"]
 		language = locale[0,2]
 		return language
 	end

 	# Method to push a message to Facebook
	def self.say(recipient_id, text)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: recipient_id },
			message: { text: text }
		}
		HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)
	end

	# To send a quick reply to user
	def self.send_quick_reply(id)
		get_profile(id)
		@language = @locale[0,2]
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id},
			message: {
				text: QUICK_REPLY_HEADER["#{@language}"],
				quick_replies: QUICK_REPLIES["#{@language}"] 
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

	def self.send_terms_and_condition(id)
	 	terms_and_condition_message = TERMS_AND_CONDITION 
			message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			message: terms_and_condition_message,
		}
		HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)	
	end

	# Typing indication:
	def self.typing_on(id)
		message_options = {
			messaging_type: "RESPONSE",
			recipient: { id: id },
			sender_action: "typing_on",
		}
		response = HTTParty.post(FB_MESSAGE,headers: HEADER, body: message_options.to_json)		
  	end

  	# Initial configuration method to get kid name 
  	def self.initial_config(id)
		say(id,ASK_KID_NAME["#{@language}"])
		Bot.on :message do |message|
			kid_name = message.text
			get_dob(id,kid_name)
		end
	end

	# Initial configuration method to get kid Date of birth
	def self.get_dob(id,kid_name)
		say(id,ASK_DOB_TEXT["#{@language}"])
		Bot.on :message do |message|
			kid_dob = message.text
			begin
				dob = Date.parse kid_dob
			rescue ArgumentError
				say(id,INVALID_DOB_ERROR_TEXT["#{@language}"])
				get_dob(id,kid_name)
			end
			if dob !=nil then
				date_full_format = dob.strftime("%d %b %Y")
				reply_text = GOT_IT_TEXT +  "#{date_full_format}"
				say(id,reply_text)
				get_gender(id,kid_name,dob)
			end
		end
	end

	# Initial configuration method to get kid Gender
	def self.get_gender(id,kid_name,kid_dob)
		say(id,"Boy or girl child?")
		Bot.on :message do |message|
			if((message.text).downcase == "boy" || (message.text).downcase == "male" ) then
				kid_gender = "male"
			elsif ((message.text).downcase == "girl" || (message.text).downcase == "female") then
				kid_gender = "female"
			else
				say(id,INVALID_GENDER_ERROR_TEXT["#{@language}"])
				get_gender(id,kid_name,kid_dob)
			end

			if kid_gender !=nil then
				VaccinationScheduleEditor.new.add_new_kid(id,kid_name,kid_gender,kid_dob)
				say(id,REGISTERATION_SUCCESSFULL_TEXT["#{@language}"])
				send_quick_reply(id)
			end
		end
	end

	# Method to edit kid name in the database
	def self.edit_kid_name(id,kid_name =nil)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if kid_name == nil then
			say(id,ASK_KID_NAME["#{@language}"])
			Bot.on :message do |message|
				user.update_attributes(:kid_name => message.text)
				reply_text = KID_NAME_UPDATED_TEXT["#{@language}"] + "#{message.text}!"
				say(id,reply_text)
				send_quick_reply(id)
			end
		else
			user.update_attributes(:kid_name => kid_name)
			reply_text = KID_NAME_UPDATED_TEXT["#{@language}"] + "#{kid_name}"
			say(id,reply_text)
			send_quick_reply(id)
		end

	end

	# Method to edit kid gender in the database
	def self.edit_kid_gender(id)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		say(id,"Male or Female kid?")
		Bot.on :message do |message|
			if((message.text).downcase == "boy" || (message.text).downcase == "male" ) then
				kid_gender = "male"
			elsif ((message.text).downcase == "girl" || (message.text).downcase == "female") then
				kid_gender = "female"
			else
				say(id,INVALID_GENDER_ERROR_TEXT["#{@language}"])
				edit_kid_gender(id,)
			end

			if kid_gender !=nil then
				user.update_attributes(:kid_gender => kid_gender)
				say(id,KID_GENDER_UPDATED_TEXT["#{@language}"])
				send_quick_reply(id)
			end
		end
	end

	# Method to edit kid date of birth in the database
	def self.edit_kid_dob(id,dob_val = nil)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		if dob_val == nil then
			say(id,ASK_DOB_TEXT["#{@language}"])
			Bot.on :message do |message|
				kid_dob = message.text
				validate_dob(id,kid_dob)
			end
		else
			validate_dob(id,dob_val)
		end

	end

	# Method to validate kid date of birth
	def self.validate_dob(id,kid_dob)
		user = VaccinationSchedule.find_by_parent_facebook_userid(id)
		begin
			dob = Date.parse kid_dob
		rescue ArgumentError
			say(id,INVALID_DOB_ERROR_TEXT["#{@language}"])
			edit_kid_dob(id)
		end
		if dob !=nil then
			date_full_format = dob.strftime("%d %b %Y")
			say(id,"Got it, #{date_full_format}")
			user.update_attributes(:kid_dob => kid_dob)
			VaccinationScheduleEditor.new.update_kid_record(id,dob)
			say(id,KID_DOB_UPDATED_TEXT["#{@language}"])
			send_quick_reply(id)
		end	
	end

	# Method used to retrive the user profile when rejoin to the bot
	def old_user(id)
		MessengerBot.say(id,OLD_USER_GREETING_CONTENT["#{@language}"])
		ProfileEditor.new.get_parent_profile(id)
		MessengerBot.send_quick_reply(id)
	end

	# Initial configuration for the bot 
	Facebook::Messenger::Subscriptions.subscribe(access_token: ENV["FB_ACCESS_TOKEN"])
	greeting_response 		 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GREETING.to_json )
	get_started_response	 =HTTParty.post(FB_PAGE,  headers: HEADER, body: GET_STARTED.to_json)
	persistent_menu_response =HTTParty.post(FB_PAGE, headers: HEADER, body: PERSISTENT_MENU.to_json)

	# Triggers whenever a message has got
	Bot.on :message do |message|
		id = message.sender["id"]
		call_message(id,message.text)
	end

	# Triggers whenever a postback happens
	Bot.on :postback do |postback|
		id = postback.sender["id"]
		call_postback(id,postback.payload)
	end

	# Method to handle bot messages
	def self.call_message(id,message_text)
		typing_on(id)
		get_profile(id)
		@language = @locale[0,2]
		case message_text.downcase
		when "hi"
			hi_message_reply_text = GREETING_MESSAGE_SALUTATION["#{@language}"] + "#{@first_name} #{@last_name}! " + HI_MESSAGE_CONTENT["#{@language}"]
			say(id,hi_message_reply_text)
			send_quick_reply(id)
		when UPCOMING_VACCINATION_MESSAGE_TEXT["#{@language}"]
			FetchVaccinationDetails.new.upcoming(id)
		when PREVIOUS_VACCINATION_MESSAGE_TEXT["#{@language}"]
			FetchVaccinationDetails.new.previous(id)
		when PROFILE_MESSAGE_TEXT["#{@language}"]
			ProfileEditor.new.get_parent_profile(id)
		when EDIT_KID_NAME_TEXT["#{@language}"]
			MessengerBot.edit_kid_name(id)
		when EDIT_KID_DOB_TEXT["#{@language}"]
			MessengerBot.edit_kid_dob(id)
		when EDIT_KID_GENDER_TEXT["#{@language}"]
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
					say(id,KID_GENDER_UPDATED_TEXT["#{@language}"])
					send_quick_reply(id)
				elsif wit_response["gender_value"][0]["value"] == "FEMALE" then
					user.update_attributes(:kid_gender => "female")
					say(id,KID_GENDER_UPDATED_TEXT["#{@language}"])
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
		get_profile(id)
		@language = @locale[0,2]
		case postback_payload
		when "GET_STARTED"
			get_profile(id)
			greeting_text = GREETING_MESSAGE_SALUTATION["#{@language}"] + "#{@first_name} #{@last_name}! " + GREETING_MESSAGE_CONTENT["#{@language}"]
			say(id,greeting_text)
			send_terms_and_condition(id)
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
			say(id, WHY_SUBSCRIBE_TEXT["#{@language}"])
		when "EDIT_KID_NAME"
			MessengerBot.edit_kid_name(id)
		when "EDIT_KID_GENDER"
			MessengerBot.edit_kid_gender(id)
		when "EDIT_KID_DOB"
			MessengerBot.edit_kid_dob(id)
		when "HI"
			hi_message_reply_text = GREETING_MESSAGE_SALUTATION["#{@language}"] + "#{@first_name} #{@last_name}! " + HI_MESSAGE_CONTENT["#{@language}"]
			say(id,hi_message_reply_text)
			send_quick_reply(id)
		else
			say(id, COULDNOT_UNDERSTAND_THE_MESSAGE_TEXT["#{@language}"])
			say(id, HELP_TEXT["#{@language}"])
		end
	end
end