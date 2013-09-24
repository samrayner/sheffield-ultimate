require 'spec_helper'

describe EmailsController do
  before :all do
    site = FactoryGirl.create(:cms_site, identifier: "sheffield-ultimate")
    ComfortableMexicanSofa::Fixture::Importer.new(site.identifier, site.identifier, :force).import!
  end

  after :all do
    [Cms::Site, Cms::Layout, Cms::Page, Cms::File].each(&:delete_all)
  end

  describe :new do
    before do
      get 'new'
    end

    it "returns http success" do
      response.should be_success
    end

    it "assigns a new email" do
      assigns(:email).should be_a_new(Email)
    end

    it "renders the email form" do
      response.should render_template("emails/_form")
    end
  end

  describe :create do
    before do
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

    context "valid" do
      before do
        post :create, email: @params
      end

      it "sets a success flash message" do
        flash[:success].should match(/thank you/i)
      end

      it "renders the email" do
        response.should render_template("contact_mailer/contact_email")
      end

      it "redirects to the contact page" do
        response.should redirect_to new_email_path
      end
    end

    context "invalid" do
      before do
        spam_params = @params
        spam_params["first_name"] = "Toast"
        post :create, email: spam_params
      end

      it "lrenders the email form" do
        response.should render_template("emails/_form")
      end
    end

    context "delivery failure" do
      before do
        email = Email.new(@params)
        email.stub(:submit).and_return(false)
        Email.stub(:new).with(@params).and_return(email)
        post :create, email: @params
      end

      it "sets an error flash message" do
        flash[:error].should match(/could not be delivered/i)
      end

      it "renders the email form" do
        response.should render_template("emails/_form")
      end
    end
  end
end
