require_relative "../../strings"

class MessengerBot
	PERSISTENT_MENU_DEFAULT = {
      "locale": "default",
      "composer_input_disabled": false,
      "call_to_actions": [{
        "title": "💉 #{UPCOMING_VACCINATION_DETAILS_BUTTON["en"]}",
        "type": "postback",
        "payload": "UPCOMING_VACCINATIONS"
      },
      {
        "title": "💉 #{PREVIOUS_VACCINATION_DETAILS_BUTTON["en"]}",
        "type": "postback",
        "payload": "PREVIOUS_VACCINATIONS"
      },
      {
        "title": "🔧 #{MORE_BUTTON["en"]}",
        "type": "nested",
        "call_to_actions": [{
          "title": "🔔 #{SUBSCRIPTION_BUTTON["en"]}",
          "type": "postback",
          "payload": "SUBSCRIPTION"
        },
        {
          "title": "👤 #{PROFILE_BUTTON["en"]}",
          "type": "postback",
          "payload": "PROFILE"
        }]
      }]
    }
end