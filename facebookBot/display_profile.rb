require 'facebook/messenger'
require 'httparty'
require 'json'

require_relative './bot.rb'
require_relative 'json_templates/template'
require_relative '../utils'

class MessengerBot

	#Method to display user profile details
	def display_profile(id,parent_first_name,parent_last_name,kid_name,kid_dob,kid_gender)
		template = GENERIC_TEMPLATE_BODY
		elements = []
		@language = MessengerBot.new.get_language(id)
		new_element = {
	            "title": "👤 #{PROFILE_BUTTON["#{@language}"]}",
	            "subtitle": "#{YOUR_NAME["#{@language}"]}: #{parent_first_name}\n#{YOUR_KID_NAME["#{@language}"]}: #{kid_name}\n#{KID_DOB["#{@language}"]}: #{kid_dob}\n#{KID_GENDER["#{@language}"]}: #{kid_gender}",
			    "buttons":[
			      {
			        "type": "postback",
			        "title": "👶 #{EDIT_KID_NAME_TEXT["#{@language}"]}",
			        "payload": "EDIT_KID_NAME"
			      },
			      {
			        "type": "postback",
			        "title": "📅 #{EDIT_KID_DOB_TEXT["#{@language}"]}",
			        "payload": "EDIT_KID_DOB"
			      },
			      {
			        "type": "postback",
			        "title": "🚻 #{EDIT_KID_GENDER_TEXT["#{@language}"]}",
			        "payload": "EDIT_KID_GENDER"
			      }
			    ]
		    }
		elements << new_element
		template[:attachment][:payload][:elements] = elements
		message_options = {
			"messaging_type": "RESPONSE",
		    "recipient": { "id": "#{id}"},
		    "message": "#{template.to_json}"
        }
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)

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