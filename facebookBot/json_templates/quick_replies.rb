require_relative '../strings'
require_relative '../bot'
Dir[File.join(__dir__, './quick_replies_strings', '*')].each { |file| require file }
class MessengerBot

 QUICK_REPLIES = {
 	"en" => QUICK_REPLY_EN,
  	"ta" => QUICK_REPLY_TA
}

end
