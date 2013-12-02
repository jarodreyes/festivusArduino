require 'sinatra'
require 'twilio-ruby'
require 'pusher'

before do
  # Setup Pusher
  Pusher.app_id = ENV['PUSHER_APP_ID']
  Pusher.key = ENV['PUSHER_KEY']
  Pusher.secret = ENV['PUSHER_SECRET']
end

get '/chaos/' do
  erb :chaos
end

# The single endpoint that our Twilio number points to.
get '/trick/?' do
  output = "Our ghoulish ghosts have heard your wish. Happy Halloween!"
  # Try to trigger a pusher event based on the Body of the incoming SMS or submitted form
  begin
    Pusher['trick_channel'].trigger('starting:', {:message => 'starting up trick'})
  rescue Pusher::Error => e
    output = "Failed: #{e.message}"
  end
  # Switch colors
  begin
    command = params['Body'].downcase
    puts Pusher['trick_channel'].trigger(command, {:message => command})
  rescue
    command = "no message"
  end

  # If the web form was submitted, render our erb template
  if params['SmsSid'] == nil
    erb :index, :locals => {:msg => output}

  # Otherwise return TwiML to send an SMS
  else
    response = Twilio::TwiML::Response.new do |r|
      r.Message output
    end
    response.text
  end
end

get '/' do
  erb :index, :locals => {:msg => "Haunted Hack"}
end
