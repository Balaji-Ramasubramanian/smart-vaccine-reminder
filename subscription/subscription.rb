require 'facebook/messenger'
require 'httparty'
require 'json'  
require_relative './subscription_template.rb'
require_relative '../facebookBot/bot.rb'
require_relative '../models/vaccination_schedule'
require_relative '../database_editors/vaccination_schedule_editor'

class SubscriptionClass

  #Method to handle subscriptions
  def subscriptions(id)
    user = VaccinationSchedule.find_by_parent_facebook_userid(id)
    if user != nil then
      subscriptions = user.subscription
      if subscriptions == true then
        show_unsubscribe(id)
      else
        show_subscribe(id)
      end
    else
      VaccinationScheduleEditor.new.add_new_kid(id," ","",Date.today)
      MessengerBot.say(id,"Please register your details first!")
      # MessengerBot.initial_config(id)
    end
  end

  #Show Subscription Template
  def show_subscribe(id)
    message_option = SUBSCRIPTION_MESSAGE_OPTION
    message_option[:recipient][:id] = id
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = "Subscribe"
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = "You are now Unsubscribed to Vaccine reminder. Do you want to Subscribe?"
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "SUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
  end

  #Show Unsubscribe Template
  def show_unsubscribe(id)
    message_option = SUBSCRIPTION_MESSAGE_OPTION
    message_option[:recipient][:id] = id
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = "Unsubscribe"
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = "You are now subscribed to Vaccine reminder. Do you want to Unsubscribe?"
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "UNSUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
  end


  #Add subscription for user to Vaccine reminder
  def subscribe(id)
    user=VaccinationSchedule.find_by_parent_facebook_userid(id)
    user.update_attributes( :subscription => true )
    MessengerBot.say(id,"You are successfully Subscribed!!")
    MessengerBot.say(id,"Thank you for subscribing, I'll send you Vaccine reminders regularly !") 
  end

  #unsubscribe a User from Vaccine reminder 
  def unsubscribe(id)
    user = VaccinationSchedule.find_by_parent_facebook_userid(id)
    user.update_attributes( :subscription => false )
    MessengerBot.say(id, "You are successfully Unsubscribed! To get regular vaccine reminders, do subscribe!")
  end 


end