require 'helper'

class TestSms < Test::Unit::TestCase
  SUCCESS_CODE  = 201
  ERROR_CODE    = -1
  FROM_NUMBER   = "502938232"
  TO_NUMBER     = "948398434"
  MESSAGE       = "Text message"
    
  def test_successful_message
    response = mock()
    Twilio::RestAccount.any_instance.stubs(:request).returns(response)
    response.expects(:code).returns(SUCCESS_CODE)
    assert_equal(true, SMS.text(MESSAGE, :from => FROM_NUMBER, :to => TO_NUMBER))
  end
  
  def test_unsuccessful_message
    response = mock()
    Twilio::RestAccount.any_instance.stubs(:request).returns(response)
    response.expects(:code).returns(ERROR_CODE)
    assert_equal(false, SMS.text(MESSAGE, :from => FROM_NUMBER, :to => TO_NUMBER))
  end
  
  def test_unsuccessful_message_with_exception
    response = stub(:code => ERROR_CODE, :body => stub(:match => []))
    Twilio::RestAccount.any_instance.stubs(:request).returns(response)
    assert_raise TypeError do 
      SMS.text!(MESSAGE, :from => FROM_NUMBER, :to => TO_NUMBER)
    end
  end
  
  def test_sending_sms_with_env_set
    ENV['TWILIO_ID']     = "twilio_id"
    ENV['TWILIO_SECRET'] = "twilio_secret"
    link                 = "/2008-08-01/Accounts/#{ENV['TWILIO_ID']}/SMS/Messages"
    
    twilio = mock()
    twilio.expects(:request).with(link, "POST", {'To' => TO_NUMBER, 'From' => FROM_NUMBER, 'Body' => MESSAGE}).returns(mock(:code => SUCCESS_CODE))
    
    Twilio::RestAccount.expects(:new).with("twilio_id", "twilio_secret").returns(twilio)
    assert_equal(true, SMS.text(MESSAGE, :from => FROM_NUMBER, :to => TO_NUMBER))
  end
  
  def test_sending_sms_without_env_set
    SMS.twilio_id     = "twilio_id"
    SMS.twilio_secret = "twilio_secret"
    link              = "/2008-08-01/Accounts/#{SMS.twilio_id}/SMS/Messages"
    
    twilio = mock()
    twilio.expects(:request).with(link, "POST", {'To' => TO_NUMBER, 'From' => FROM_NUMBER, 'Body' => MESSAGE}).returns(mock(:code => SUCCESS_CODE))
    
    Twilio::RestAccount.expects(:new).with("twilio_id", "twilio_secret").returns(twilio)
    assert_equal(true, SMS.text(MESSAGE, :from => FROM_NUMBER, :to => TO_NUMBER))
  end
end
