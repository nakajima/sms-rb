# sms-rb

Send text messages with Twilio (http://www.twilio.com). Easily.

## USAGE

Set the following ENV variables:

* `TWILIO_ID` - Your Twilio API id token.
* `TWILIO_SECRET` - Your Twilio API secret token.
* `TWILIO_PHONE` (optional) - One of your Twilio phone numbers.

Then send some texts!

If you've set `ENV['TWILIO_PHONE']`:

    SMS.text "Hello!", :to => "5558675309"

If you haven't:

    SMS.text "Hello!", :to => "5558675309", :from => "5555555555"

Calling `SMS.text` returns true or false depending on whether or not
it was a success. You can also call `SMS.text!`, which will raise an
error if the text does not get sent successfully.
