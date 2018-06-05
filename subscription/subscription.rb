require 'facebook/messenger'
require 'httparty'
require 'json'  
require_relative './subscription_template'
require_relative '../facebookBot/bot'
require_relative '../models/vaccination_schedule'
require_relative '../database_editors/vaccination_schedule_editor'
require_relative './subscription_strings'
class SubscriptionClass

  #Method to handle subscriptions
  def subscriptions(id)
    @language = MessengerBot.new.get_language(id)
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
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = SUBSCRIBE_BUTTON["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:buttons][1][:title] = WHY_SUBSCRIBE_BUTTON["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:title] = SUBSCRIPTION_TEXT["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = SHOW_SUBSCRIBE_SUBTITLE_TEXT["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "SUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
  end

  #Show Unsubscribe Template
  def show_unsubscribe(id)
    message_option = SUBSCRIPTION_MESSAGE_OPTION
    message_option[:recipient][:id] = id
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = UNSUBSCRIBE_BUTTON["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:buttons][1][:title] = WHY_SUBSCRIBE_BUTTON["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:title] = SUBSCRIPTION_TEXT["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = SHOW_UNSUBSCRIBE_SUBTITLE_TEXT["#{@language}"]
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "UNSUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
  end


  #Add subscription for user to Vaccine reminder
  def subscribe(id)
    user=VaccinationSchedule.find_by_parent_facebook_userid(id)
    user.update_attributes( :subscription => true )
    MessengerBot.say(id,SUCCESSFULLY_SUBSCRIBED_TEXT1["#{@language}"])
    MessengerBot.say(id,SUCCESSFULLY_SUBSCRIBED_TEXT2["#{@language}"]) 
  end

  #unsubscribe a User from Vaccine reminder 
  def unsubscribe(id)
    user = VaccinationSchedule.find_by_parent_facebook_userid(id)
    user.update_attributes( :subscription => false )
    MessengerBot.say(id, SUCCESSFULLY_UNSUBSCRIBED_TEXT["#{@language}"])
  end 


end