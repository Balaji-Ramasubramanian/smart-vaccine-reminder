 require 'facebook/messenger'
require 'httparty'
require 'json'

require_relative './bot.rb'
require_relative 'json_templates/template.rb'
require_relative '../utils'

class MessengerBot

	def display_vaccination_dates(id,vaccination_dates)
		puts "Inside display_vaccination_dates"
		template = TEMPLATE_BODY
		elements = []
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
        # puts message_options
		res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_options)
	end

end