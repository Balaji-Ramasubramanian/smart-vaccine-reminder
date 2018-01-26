 require 'facebook/messenger'
require 'httparty'
require 'json'

require_relative './bot.rb'
require_relative 'json_templates/template.rb'
require_relative '../utils'

class MessengerBot

	def display_vaccination_dates(id,vaccination_dates)
		template = TEMPLATE_BODY
		elements = []
		if vaccination_dates.length == 0 then
			MessengerBot.say(id,"No upcoming vaccines available")
		end
		for i in 0..9
			break if i > vaccination_dates.length-1
			vaccine_name = vaccination_dates[i][:vaccine]
			vaccine_date = vaccination_dates[i][:date]
			vaccine_url  = vaccination_dates[i][:url]
			new_element = {
	            "title": "#{vaccine_name.upcase}",
	            "subtitle": "Due Date: #{vaccine_date}",
			    "buttons":[
			      {
			        "type": "web_url",
			        "title": "Details",
			        "url": "#{vaccine_url}"
			      }
			    ]
		    }
		elements << new_element
		end
		template[:attachment][:payload][:elements] = elements
		message_options = {
			"messaging_type": "RESPONSE",
		    "recipient": { "id": "#{id}"},
		    "message": "#{template.to_json}"
        }
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)

		Bot.on :message do |message|
			puts "inside bot.on message -> display_vaccination_dates"
			id = message.sender["id"]
			MessengerBot.call_message(id,message.text)
		end


		Bot.on :postback do |postback|
			id = postback.sender["id"]
			puts "inside postback bot.on -> display_vaccination_dates"
			MessengerBot.call_postback(id,postback.payload)
		end
	end

end