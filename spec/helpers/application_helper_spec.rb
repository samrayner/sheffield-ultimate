require 'spec_helper'

describe ApplicationHelper do
  describe "#alert_class" do
    it "should return the twitterized type for alert" do
      expect(alert_class(:alert)).to eq("alert alert-warning")
    end

    it "should return the twitterized type for error" do
      expect(alert_class(:error)).to eq("alert alert-danger")
    end

    it "should return the twitterized type for notice" do
      expect(alert_class(:notice)).to eq("alert alert-info")
    end

    it "should return the twitterized type for success" do
      expect(alert_class(:success)).to eq("alert alert-success")
    end

    it "should return the twitterized type for anything else as info" do
      expect(alert_class("")).to eq("alert alert-info")
    end
  end
end
