require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'dotenv/load'

# Talk to Facebook
get '/webhook' do
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

#Show nothing in the browser
get "/" do
  "Nothing to see here"
end

get "/terms&conditions" do
	"Terms and conditions page here"
end

get "/privacy-policy" do
	"Privacy Policy"
end