require_relative "../../strings"

class MessengerBot
  PERSISTENT_MENU_TA = {
      "locale": "ta_IN",
      "composer_input_disabled": false,
      "call_to_actions": [{
        "title": "💉 #{UPCOMING_VACCINATION_DETAILS_BUTTON["ta"]}",
        "type": "postback",
        "payload": "UPCOMING_VACCINATIONS"
      },
      {
        "title": "💉 #{PREVIOUS_VACCINATION_DETAILS_BUTTON["ta"]}",
        "type": "postback",
        "payload": "PREVIOUS_VACCINATIONS"
      },
      {
        "title": "🔧 #{MORE_BUTTON["ta"]}",
        "type": "nested",
        "call_to_actions": [{
          "title": "🔔 #{SUBSCRIPTION_BUTTON["ta"]}",
          "type": "postback",
          "payload": "SUBSCRIPTION"
        },
        {
          "title": "👤 #{PROFILE_BUTTON["ta"]}",
          "type": "postback",
          "payload": "PROFILE"
        }]
      }]
    }
end