class MessengerBot 

  GENERIC_TEMPLATE_BODY = {
    "attachment": {
      "type": "template",
      "payload":{
        "template_type": "generic",
         "elements":[{
            "title": "",
            "subtitle": "",
            "buttons":[{
              "type": "",
              "title": "",
              "payload": ""
            }]      
          }]
      }
    }
  }

  TERMS_AND_CONDITION ={
    "attachment":{
      "type": "template",
      "payload":{
        "template_type": "button",
        "text": "To know about Terms and Condition,",
        "buttons": [{
          "type": "web_url",
          "title": "Terms and Condition",
          "url": "https://smart-vaccine-reminder.herokuapp.com/terms&conditions"
          },
          {
          "type": "web_url",
          "title": "Privacy Policy",
          "url": "https://smart-vaccine-reminder.herokuapp.com/privacy-policy"
          }]
      }
    }
  }

end