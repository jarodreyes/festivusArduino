require 'sinatra'
require 'twilio-ruby'
require 'twilio-ruby/rest/messages'
require 'pusher'
require 'sanitize'

before do
  # Setup 
  Pusher.app_id = ENV['FESTIVUS_APP']
  Pusher.key = ENV['FESTIVUS_KEY']
  Pusher.secret = ENV['FESTIVUS_SECRET']
  @client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']
  @mmsclient = @client.accounts.get(ENV['TWILIO_SID'])
end

def sendFestivus(from, to, body, media)
  if media.nil?
    message = @client.account.messages.create(
      :from => from,
      :to => to,
      :body => body
    )
  else
    message = @mmsclient.messages.create(
      :from => from,
      :to => to,
      :body => body,
      :media_url => media,
    )
  end
  puts message.to
end

get '/live?*' do
  erb :live
end

get '/trick/?' do
  @phone_number = Sanitize.clean(params[:From])
  output = "Happy Festivus from the REST of us!"
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
    else
      puts Pusher['festivus_channel'].trigger(command, {:message => command})
      output = "Available Festivus commands: blue, red, green or ???"
      skip_media = true
    end
  rescue
    command = "no message"
  end

  if params['SmsSid'] == nil
    erb :index, :locals => {:msg => output}
  else
    @picture_url = "http://media.egotvonline.com/wp-content/uploads/2011/11/Funny-Portrait_350x446.jpg"
    if skip_media
      message = @client.account.messages.create(
        :from => '2024173378',
        :to => @phone_number,
        :body => output
      )
    else
      message = @mmsclient.messages.create(
        :from => 'TWILIO',
        :to => @phone_number,
        :body => output,
        :media_url => @picture_url,
      )
    end
    puts message.to
  end
end

get '/' do
  erb :index, :locals => {:msg => "Happy Festivus!"}
end
