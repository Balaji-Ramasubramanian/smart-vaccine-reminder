require_relative "../strings"
Dir[File.join(__dir__, './persistent_menu_strings', '*')].each { |file| require file }
class MessengerBot
  
  PERSISTENT_MENU = {
    "persistent_menu": [
      PERSISTENT_MENU_DEFAULT,
      PERSISTENT_MENU_TA
    ]
  }

end