require 'sinatra'
require 'sinatra/activerecord'
require 'rake'
require 'dotenv/load'

# Talk to Facebook
get '/webhook' do
  params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
end

get "/" do
  "Nothing to see here"
end