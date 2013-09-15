require 'spec_helper'

describe EmailsController do
  describe :new do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "assigns a new email" do
      get 'new'
      assigns(:email).should be_a_new(Email)
    end

    it "renders the email form" do
      get 'new'
      response.should render_template("emails/_form")
    end
  end

  describe :create do
    before :all do
      @params = { "name" => "Sam Rayner", "email" => "sam@example.com", "message" => "Hello" }
    end

    it "returns http success" do
      get 'create'
      response.should be_success
    end

    it "assigns a new email from the params" do
      email = Email.new(@params)
      Email.should_receive(:new).with(@params).and_return(email)
      post :create, email: @params
    end

    it "delivers the email" do
      email = Email.new(@params)
      Email.stub(:new).and_return(email)
      email.should_receive(:submit)
      post :create, email: @params
    end

    it "sets a success flash message" do
      post :create, email: @params
      flash[:success].should match(/thank you/i)
    end

    it "redirects to the contact page" do
      post :create, email: @params
      response.should redirect_to new_email_path
    end

    context "spam" do
      before :each do
        spam_params = @params
        spam_params["first_name"] = "Toast"
        post :create, email: spam_params
      end

      it "should set render the form" do
        response.should render_template("emails/_form")
      end
    end

    context "delivery failure" do
      before :each do
        @email = Email.new(@params)
        @email.stub(:submit).and_return(false)
        Email.stub(:new).with(@params).and_return(@email)
        Email.stub(:attributes).and_return([])
        post :create, email: @params
      end

      it "should set the flash" do
        flash[:error].should match(/could not be delivered/i)
      end

      it "should set render the form" do
        response.should render_template("emails/_form")
      end
    end
  end
end
