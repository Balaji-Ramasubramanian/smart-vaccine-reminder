class MessengerBot
  PERSISTENT_MENU = {
    "persistent_menu": [
      {
        "locale": "default",
        "call_to_actions": [
          {
            "title": "Upcoming Vaccination Details",
            "type": "postback",
            "payload": "UPCOMING_VACCINATIONS"
          },
          {
            "title": "Previous Vaccination Details",
            "type": "postback",
            "payload": "PREVIOUS_VACCINATIONS"
          },
          {
            "title": "More",
            "type": "nested",
            "call_to_actions": [
              {
              "title": "Subscription 👍",
              "type": "postback",
              "payload": "SUBSCRIPTION"
              },
              {
                "title": "Profile",
                "type": "postback",
                "payload": "PROFILE"
              }
             ]
           }
          ]
    }
  ]
}
end