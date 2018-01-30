class SubscriptionClass
     SUBSCRIPTION_MESSAGE_OPTION = {
         "messaging_type": "RESPONSE",
         "recipient": { "id": "0" },
         "message":{
           "attachment":{
             "type": 'template',
             "payload":{
               "template_type": "generic",
               "elements":[
                 {
                   "title": "Subscription",
                   "subtitle": "You are now Unsubscribed!",
                   "buttons":[
                    {
                      "type": "postback",
                      "title": "Subscribe",
                      "payload": "SUBSCRIBE"
                    }, 
                    {
                      "type": "postback",
                      "title": "Why Subscribe?",
                      "postback": "WHY_SUBSCRIBE"
                    }             
                ]   
                }
              ]
              }  
            }
          }
        }

  end