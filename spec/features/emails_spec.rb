require 'rails_helper'

describe "Emails" do
  before :all do
    delete_all_cms_data
    import_fixtures("sheffield-ultimate")
  end

  before do
    visit contact_path
  end

  context "sending an email" do
    it "delivers a valid message" do
      within "#new_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "sam@samrayner.com"
        fill_in "Message", with: "What a great website."
        click_button "Send"
      end
      expect(page.body).to have_content("Thank you")
    end

    it "does not deliver a message with a missing name" do
      within "#new_email" do
        fill_in "Email", with: "sam@example.com"
        fill_in "Message", with: "What a great website."
        click_button "Send"
        expect(page.body).to have_content("can't be blank")
      end
    end

    it "does not deliver a message with an invalid email" do
      within "#new_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "not_an_email"
        fill_in "Message", with: "What a great website."
        click_button "Send"
        expect(page.body).to have_content("is invalid")
      end
    end

    it "does not deliver a message with a blank email" do
      within "#new_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Message", with: "What a great website."
        click_button "Send"
        expect(page.body).to have_content("can't be blank")
      end
    end

    it "does not deliver a message with a blank message" do
      within "#new_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "sam@example.com"
        click_button "Send"
        expect(page.body).to have_content("can't be blank")
      end
    end

    it "does not deliver spam" do
      within "#new_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "spammer@spammyjunk.com"
        fill_in "Message", with: "All the junk you'll never need."
        fill_in "First name", with: "Want to buy some gold?"
        click_button "Send"
        expect(page.body).to have_content("must be blank")
      end
    end
  end

  context "subscribing to receive emails" do
    it "delivers a valid message" do
      within "#new_subscription_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "sam@samrayner.com"
        click_button "Subscribe"
      end
      expect(page.body).to have_content("Thank you")
    end

    it "does not deliver a message with a missing name" do
      within "#new_subscription_email" do
        fill_in "Email", with: "sam@example.com"
        click_button "Subscribe"
        expect(page.body).to have_content("can't be blank")
      end
    end

    it "does not deliver a message with an invalid email" do
      within "#new_subscription_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "not_an_email"
        click_button "Subscribe"
        expect(page.body).to have_content("is invalid")
      end
    end

    it "does not deliver a message with a blank email" do
      within "#new_subscription_email" do
        fill_in "Name", with: "Sam Rayner"
        click_button "Subscribe"
        expect(page.body).to have_content("can't be blank")
      end
    end

    it "does not deliver spam" do
      within "#new_subscription_email" do
        fill_in "Name", with: "Sam Rayner"
        fill_in "Email", with: "spammer@spammyjunk.com"
        fill_in "First name", with: "Want to buy some gold?"
        click_button "Subscribe"
        expect(page.body).to have_content("must be blank")
      end
    end
  end
end
