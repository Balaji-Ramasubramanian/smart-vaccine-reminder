require 'facebook/messenger'
require 'httparty'
require 'json'  
require_relative './subscription_template.rb'
require_relative '../facebookBot/bot.rb'
require_relative '../models/vaccination_schedule'

class SubscriptionClass

  def subscriptions(id)
    @m = VaccinationSchedule.find_by_parent_facebook_userid(id)
      subscriptions = @m.subs
      if subscriptions == true then
        show_unsubscribe(id)
      else
        show_subscribe(id)
      end
  end


  def show_subscribe(id)
    message_option = SUBSCRIPTION_MESSAGE_OPTION
    message_option[:recipient][:id] = id
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = "Subscribe"
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = "You are now Unsubscribed to Vaccine Remainder. Do you want to Subscribe?"
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "SUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
    puts res
  end

  def show_unsubscribe(id)
    message_option = SUBSCRIPTION_MESSAGE_OPTION
    message_option[:recipient][:id] = id
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:title] = "Unsubscribe"
    message_option[:message][:attachment][:payload][:elements][0][:subtitle] = "You are now subscribed to Vaccine Remainder. Do you want to Unsubscribe?"
    message_option[:message][:attachment][:payload][:elements][0][:buttons][0][:payload] = "UNSUBSCRIBE"
    res = HTTParty.post(FB_MESSAGE, headers: HEADER, body: message_option.to_json)
    puts res
  end



  def subscribe(id)
     @m=VaccinationSchedule.find_by_parent_facebook_userid(id)
      @m.update_attributes( :subs => true )
      MessengerBot.say(id,"You are successfully Subscribed!!")
      MessengerBot.say(id,"Thank you for subscribing, I'll send you Vaccine Remainders regularly !") 
  end

  def unsubscribe(id)
    @m = VaccinationSchedule.find_by_parent_facebook_userid(id)
     @m.update_attributes( :subs => false )
     MessengerBot.say(id, "You are successfully Unsubscribed! To get regular vaccine remainders, do subscribe!")
  end 


end