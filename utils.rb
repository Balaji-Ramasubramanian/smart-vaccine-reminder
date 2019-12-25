# Facebook page graph API to authenticate to a Facebook Page
FB_PAGE = "https://graph.facebook.com/v4.0/me/messenger_profile?access_token=" + ENV["FB_ACCESS_TOKEN"]
# Facebook Message API
FB_MESSAGE = "https://graph.facebook.com/v4.0/me/messages?access_token=" + ENV["FB_ACCESS_TOKEN"]
# Facebook graph API URL to get user profile
FB_PROFILE = "https://graph.facebook.com/v4.0/"
# Facebook graph API to get profile- fileds to be get.
FB_PROFILE_FIELDS = "?fields=first_name,last_name,profile_pic,locale,gender&access_token=" + ENV["FB_ACCESS_TOKEN"]

# JSON header content
HEADER = { "Content-Type" => "application/json" }