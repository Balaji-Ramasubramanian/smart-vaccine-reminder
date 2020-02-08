require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'dotenv/load'

# Talk to Facebook
get '/webhook' do
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

#Show the home page
get "/" do
  redirect '/index.html'
end

#Show the terms and conditions page
get "/termsandconditions" do
	"Terms and conditions page here"
end

#Show the privacy polic page
get "/privacy-policy" do
	"Privacy Policy"
end