require 'spec_helper'

describe EmailsController do
  before :all do
    import_fixtures("sheffield-ultimate")
  end

  after :all do
    delete_all_cms_data
  end

  describe :new do
    before do
      get :new
    end

    it "returns http success" do
      response.should be_success
    end

    it "assigns a new subscription email" do
      assigns(:contact_email).should be_a_new(Email)
    end

    it "assigns a new contact email" do
      assigns(:subscription_email).should be_a_new(Email)
    end

    it "renders the contact page" do
      response.should render_template("emails/_contact_form")
    end
  end

  shared_examples "an email form" do |action_key, params_key|
    let(:params) do
      { "name" => "Sam Rayner", "email" => "sam@example.com", "message" => "Hello" }
    end
    let(:action) { post action_key, "#{params_key}" => params }
    let!(:email) { Email.new(params) }

    it "delivers the email" do
      Email.stub(:new).and_return(email)
      email.should_receive(:submit)
      action
    end

    context "valid" do
      before { action }

      it "sets a success flash message" do
        flash[:success].should match(/thank you/i)
      end

      it "renders the email" do
        response.should render_template("contact_mailer/contact_email")
      end

      it "redirects to the contact page" do
        response.should redirect_to contact_path
      end
    end

    context "invalid" do
      before do
        spam_params = params
        spam_params["first_name"] = "Toast"
        post :create, email: spam_params
      end

      it "renders the contact page" do
        response.should render_template("emails/_contact_form")
      end
    end

    context "delivery failure" do
      before do
        email.stub(:submit).and_return(false)
        Email.stub(:new).and_return(email)
        action
      end

      it "sets an error flash message" do
        flash[:error].should match(/sorry/i)
      end

      it "renders the contact page" do
        response.should render_template("emails/_contact_form")
      end
    end
  end

  describe :create do
    let(:action) do
      post :create, email: { name: "Sam", email: "a@b.com", message: "Hello"}
    end

    it_behaves_like "an email form", :create, :email

    it "assigns a new contact email" do
      action
      assigns(:contact_email).message.should == "Hello"
    end

    it "assigns a new subscription email" do
      action
      assigns(:subscription_email).should be_a_new(Email)
    end
  end

  describe :subscribe do
    let(:action) { post :subscribe, subscription_email: { name: "Sam", email: "a@b.com", message: "Subscribe"} }

    it_behaves_like "an email form", :subscribe, :subscription_email

    it "assigns a new subscription email" do
      action
      assigns(:subscription_email).message.should == "Subscribe"
    end

    it "assigns a new contact email" do
      action
      assigns(:contact_email).should be_a_new(Email)
    end
  end
end
