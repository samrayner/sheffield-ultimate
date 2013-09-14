require 'spec_helper'

describe ApplicationHelper do
  describe :alert_class do
    it "returns a string of alert classes" do
      alert_class(:irrelevant).should include("alert alert-")
    end
  end

  describe :nav_link do
    before :each do
      self.request = double('request', fullpath: "path/to/page")
    end

    it "should add .active to the current page list item" do
      nav_link("Title", "path").should == '<li class="active"><a href="path">Title</a></li>'
    end

    it "should not add .active to inactive list items" do
      nav_link("Title", "not_path").should == '<li class=""><a href="not_path">Title</a></li>'
    end
  end
end
