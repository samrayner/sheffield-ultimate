require 'spec_helper'

describe ApplicationHelper do
  describe "#alert_class" do
    it "should return the twitterized type for alert" do
      alert_class(:alert).should == "alert alert-warning"
    end

    it "should return the twitterized type for error" do
      alert_class(:error).should == "alert alert-danger"
    end

    it "should return the twitterized type for notice" do
      alert_class(:notice).should == "alert alert-info"
    end

    it "should return the twitterized type for success" do
      alert_class(:success).should == "alert alert-success"
    end

    it "should return the twitterized type for anything else as info" do
      alert_class("").should == "alert alert-info"
    end
  end
end
