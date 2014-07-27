require 'rails_helper'

describe Email do
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:message) }
    it { is_expected.to validate_absence_of(:first_name) }
    it { is_expected.not_to allow_value("test").for(:email) }
    it { is_expected.not_to allow_value("test@test").for(:email) }
    it { is_expected.to allow_value("test@test.com").for(:email) }
  end

  describe "initializing with parameters" do
    let(:email) { Email.new(name: "Sam Rayner", email: "test@example.com", message: "Hello") }

    it "sets the name" do
      expect(email.name).to eq("Sam Rayner")
    end

    it "sets the email" do
      expect(email.email).to eq("test@example.com")
    end

    it "sets the message" do
      expect(email.message).to eq("Hello")
    end
  end

  describe "#submit" do
    it "sends an email to EH" do
      FactoryGirl.build(:email).submit
      expect(ActionMailer::Base.deliveries.last.subject).to eq("Message From Website Contact Form")
    end
  end
end
