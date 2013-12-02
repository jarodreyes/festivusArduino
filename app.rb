require 'sinatra'
require 'twilio-ruby'
require 'pusher'

before do
  # Setup 
  Pusher.app_id = ENV['FESTIVUS_APP']
  Pusher.key = ENV['FESTIVUS_KEY']
  Pusher.secret = ENV['FESTIVUS_SECRET']
end

get '/live?*' do
  erb :live
end

get '/trick/?' do
  output = "Happy Festivus! The festival for the rest of us!"
  begin
    Pusher['festivus_channel'].trigger('starting:', {:message => 'starting up trick'})
  rescue Pusher::Error => e
    output = "Failed: #{e.message}"
  end
  # Switch colors
  begin
    command = params['Body'].downcase
    case command
    when 'blue'
      puts Pusher['festivus_channel'].trigger('blue', {:message => 'blue'})
    when 'red'
      puts Pusher['festivus_channel'].trigger('red', {:message => 'red'})
    when 'green'
      puts Pusher['festivus_channel'].trigger('green', {:message => 'green'})
    when 'owl'
      puts Pusher['festivus_channel'].trigger('owl', {:message => 'drawMe'})
    when 'commands'
      output = "Available Commands: blue, red, green or ?"
    else
      puts Pusher['festivus_channel'].trigger(command, {:message => command})
    end
  rescue
    command = "no message"
  end

  if params['SmsSid'] == nil
    erb :index, :locals => {:msg => output}
  else
    response = Twilio::TwiML::Response.new do |r|
      r.Sms output
    end
    response.text
  end
end

get '/' do
  erb :index, :locals => {:msg => "Happy Festivus"}
end
