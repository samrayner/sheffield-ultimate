require 'spec_helper'

describe EventsController do
  describe :feed do
    before do
      get 'feed'
    end

    it "returns http success" do
      response.should be_success
    end

    it "renders with JSON header" do
      response.header['Content-Type'].should include 'application/json'
    end

    it "returns valid json" do
      ActiveSupport::JSON.decode(response.body).should_not be_nil
    end
  end
end
