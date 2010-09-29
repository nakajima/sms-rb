require 'rubygems'
require File.join(File.dirname(__FILE__), 'sms', 'twiliolib')

module SMS

  class << self
    attr_accessor :twilio_id
    attr_accessor :twilio_phone
    attr_accessor :twilio_secret
    def twilio_send
      "/2008-08-01/Accounts/#{self.twilio_id||ENV['TWILIO_ID']}/SMS/Messages"
    end
  end
  

  def self.text(message, options={})
    twilio = Twilio::RestAccount.new self.twilio_id||ENV['TWILIO_ID'], self.twilio_secret||ENV['TWILIO_SECRET']
    res = twilio.request self.twilio_send, 'POST',
      'To' => options[:to],
      'From' => options[:from] || (self.twilio_phone||ENV['TWILIO_PHONE']),
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
