require "spec_helper"

describe ContactMailer do
  let(:email)  { FactoryGirl.build(:email) }
  let(:mailer) { ContactMailer.contact_email(email) }

  describe :contact_email do
    it "sends to the correct address" do
      mailer.to.should == ["info@sheffieldultimate.co.uk"]
    end

    it "sends to the correct address" do
      mailer.subject.should == "Message From Website Contact Form"
    end

    it "has the correct from" do
      mailer.from.should == [email.email]
    end

    it "has the correct reply_to" do
      mailer.reply_to.should == [email.email]
    end
  end

  describe :deliver do
    before do
      mailer.deliver
    end

    it "delivers the email" do
      ActionMailer::Base.deliveries.last.from.should include(email.email)
    end
  end
end
