require 'spec_helper'

describe EventsController do
  describe :feed do
    before do
      get :feed
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it "renders with JSON header" do
      expect(response.header['Content-Type']).to include 'application/json'
    end

    it "returns valid json" do
      expect(ActiveSupport::JSON.decode(response.body)).not_to be_nil
    end
  end
end
