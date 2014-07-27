require 'rails_helper'

describe ContactMailer do
  let(:email)  { FactoryGirl.build(:email) }
  let(:mailer) { ContactMailer.contact_email(email) }

  describe "#contact_email" do
    it "sends to the correct address" do
      expect(mailer.to).to eq(["info@sheffieldultimate.co.uk"])
    end

    it "sends to the correct address" do
      expect(mailer.subject).to eq("Message From Website Contact Form")
    end

    it "has the correct from" do
      expect(mailer.from).to eq([email.email])
    end

    it "has the correct reply_to" do
      expect(mailer.reply_to).to eq([email.email])
    end
  end

  describe "#deliver" do
    before do
      mailer.deliver
    end

    it "delivers the email" do
      expect(ActionMailer::Base.deliveries.last.from).to include(email.email)
    end
  end
end
