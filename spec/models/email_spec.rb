require 'spec_helper'

describe Email do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:message) }
    it { should validate_absence_of(:first_name) }
    it { should_not allow_value("test").for(:email) }
    it { should_not allow_value("test@test").for(:email) }
    it { should allow_value("test@test.com").for(:email) }
  end

  describe "initializing with parameters" do
    let(:email) { Email.new(name: "Sam Rayner", email: "test@example.com", message: "Hello") }

    it "sets the name" do
      email.name.should == "Sam Rayner"
    end

    it "sets the email" do
      email.email.should == "test@example.com"
    end

    it "sets the message" do
      email.message.should == "Hello"
    end
  end

  describe :submit do
    it "sends an email to EH" do
      FactoryGirl.build(:email).submit
      ActionMailer::Base.deliveries.last.subject.should == "Message From Website Contact Form"
    end
  end
end
