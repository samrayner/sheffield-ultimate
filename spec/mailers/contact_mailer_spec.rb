require "spec_helper"

describe ContactMailer do
  before :all do
    @email = FactoryGirl.build(:email)
    @mailer = ContactMailer.contact_email(@email)
  end

  describe :contact_email do
    it "sends to the correct address" do
      @mailer.to.should == ["info@sheffieldultimate.co.uk"]
    end

    it "sends to the correct address" do
      @mailer.subject.should == "Message From Website Contact Form"
    end

    it "has the correct from" do
      @mailer.from.should == [@email.email]
    end

    it "has the correct reply_to" do
      @mailer.reply_to.should == [@email.email]
    end
  end

  describe :deliver do
    it "delivers the email" do
      @mailer.deliver
      ActionMailer::Base.deliveries.last.from.should include(@email.email)
    end
  end
end
