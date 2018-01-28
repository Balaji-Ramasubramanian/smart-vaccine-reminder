require 'wit'

class Wit

	#Method to get entities from wit server
	def get_intent(word)
		client = Wit.new(access_token: ENV["WIT_ACCESS_TOKEN"])
		response = client.message(word)

		if response["entities"]["intent"] != nil then
			if response["entities"].length >1 then
				return response["entities"]
			else
				return response["entities"]["intent"][0]["value"]
			end
		elsif response["entities"]["greetings"] != nil then
			return "HI"	
		else 
			return "NOTHING"
		end

	end
end