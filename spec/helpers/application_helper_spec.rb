require 'spec_helper'

describe ApplicationHelper do
  describe :alert_class do
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

  describe :nav_link do
    before do
      self.request = double('request', fullpath: "path/to/page")
    end

    it "should add .active to the current page list item" do
      nav_link("Title", "path").should == '<li class="active"><a href="path">Title</a></li>'
    end

    it "should not add .active to inactive list items" do
      nav_link("Title", "not_path").should == '<li class=""><a href="not_path">Title</a></li>'
    end
  end

  describe :html_obfuscate do
    it "should encode a string correctly" do
      html_obfuscate("info@sheffieldultimate.co.uk").should == "&#105;&#110;&#102;&#111;&#64;&#115;&#104;&#101;&#102;&#102;&#105;&#101;&#108;&#100;&#117;&#108;&#116;&#105;&#109;&#97;&#116;&#101;&#46;&#99;&#111;&#46;&#117;&#107;"
    end
  end
end
