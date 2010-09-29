require 'rubygems'
require File.join(File.dirname(__FILE__), 'sms', 'twiliolib')

module SMS
  TWILIO_SEND = "/2008-08-01/Accounts/#{ENV['TWILIO_ID']}/SMS/Messages"

  def self.text(message, options={})
    twilio = Twilio::RestAccount.new ENV['TWILIO_ID'], ENV['TWILIO_SECRET']
    res = twilio.request TWILIO_SEND, 'POST',
      'To' => options[:to],
      'From' => options[:from] || ENV['TWILIO_PHONE'],
      'Body' => message
    if res.code.to_i == 201
      true
    else
      if options[:raise]
        raise(res.body.match(/<Message>(Message body is required)<\/Message>/)[1])
      else
        false
      end
    end
  end

  def self.text!(message, options={})
    text(message, options.merge(:raise => true))
  end
end
