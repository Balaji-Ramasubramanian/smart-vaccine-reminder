FB_PAGE = "https://graph.facebook.com/v2.6/me/messenger_profile?access_token=" + ENV["FB_ACCESS_TOKEN"]
FB_MESSAGE = "https://graph.facebook.com/v2.6/me/messages?access_token=" + ENV["FB_ACCESS_TOKEN"]
FB_PROFILE = "https://graph.facebook.com/v2.6/"
FB_PROFILE_FIELDS = "?fields=first_name,last_name,profile_pic,locale,gender&access_token=" + ENV["FB_ACCESS_TOKEN"]
HEADER = { "Content-Type" => "application/json" }