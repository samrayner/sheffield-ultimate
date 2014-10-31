require 'rails_helper'

describe EmailsController do
  before :all do
    delete_all_cms_data
    import_fixtures("sheffield-ultimate")
  end

  describe "#new" do
    before do
      get :new
    end

    it "returns http success" do
      expect(response).to be_success
    end

    it "assigns a new subscription email" do
      expect(assigns(:contact_email)).to be_a_new(Email)
    end

    it "assigns a new contact email" do
      expect(assigns(:subscription_email)).to be_a_new(Email)
    end

    it "renders the contact page" do
      expect(response).to render_template("emails/_contact_form")
    end
  end

  shared_examples "an email form" do |action_key, params_key|
    let(:params) do
      { "name" => "Sam Rayner", "email" => "sam@example.com", "message" => "Hello" }
    end
    let(:action) { post action_key, "#{params_key}" => params }
    let!(:email) { Email.new(params) }

    it "delivers the email" do
      allow(Email).to receive(:new).and_return(email)
      expect(email).to receive(:submit)
      action
    end

    context "valid" do
      before { action }

      it "sets a success flash message" do
        expect(flash[:success]).to match(/thank you/i)
      end

      it "renders the email" do
        expect(response).to render_template("contact_mailer/contact")
      end

      it "redirects to the contact page" do
        expect(response).to redirect_to contact_path
      end
    end

    context "invalid" do
      before do
        spam_params = params
        spam_params["first_name"] = "Toast"
        post :create, email: spam_params
      end

      it "renders the contact page" do
        expect(response).to render_template("emails/_contact_form")
      end
    end

    context "delivery failure" do
      before do
        allow(email).to receive(:submit).and_return(false)
        allow(Email).to receive(:new).and_return(email)
        action
      end

      it "sets an error flash message" do
        expect(flash[:error]).to match(/sorry/i)
      end

      it "renders the contact page" do
        expect(response).to render_template("emails/_contact_form")
      end
    end
  end

  describe "#create" do
    let(:action) do
      post :create, email: { name: "Sam", email: "a@b.com", message: "Hello"}
    end

    it_behaves_like "an email form", :create, :email

    it "assigns a new contact email" do
      action
      expect(assigns(:contact_email).message).to eq("Hello")
    end

    it "assigns a new subscription email" do
      action
      expect(assigns(:subscription_email)).to be_a_new(Email)
    end
  end

  describe "#subscribe" do
    let(:action) { post :subscribe, subscription_email: { name: "Sam", email: "a@b.com", message: "Subscribe"} }

    it_behaves_like "an email form", :subscribe, :subscription_email

    it "assigns a new subscription email" do
      action
      expect(assigns(:subscription_email).message).to eq("Subscribe")
    end

    it "assigns a new contact email" do
      action
      expect(assigns(:contact_email)).to be_a_new(Email)
    end
  end
end
