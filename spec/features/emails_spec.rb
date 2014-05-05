require 'spec_helper'

describe "Emails" do
  before :all do
    import_fixtures("sheffield-ultimate")
  end

  after :all do
    delete_all_cms_data
  end

  it "delivers a valid message" do
    visit new_email_path
    fill_in 'Name', with: 'Sam Rayner'
    fill_in 'Email', with: 'sam@samrayner.com'
    fill_in 'Message', with: 'What a great website.'
    click_button 'Send'
    page.body.should have_content('Thank you')
  end

  it "does not deliver a message with a missing name" do
    visit new_email_path
    fill_in 'Email', with: 'sam@example.com'
    fill_in 'Message', with: 'What a great website.'
    click_button 'Send'
    page.body.should have_content("can't be blank")
  end

  it "does not deliver a message with an invalid email" do
    visit new_email_path
    fill_in 'Name', with: 'Sam Rayner'
    fill_in 'Email', with: 'not_an_email'
    fill_in 'Message', with: 'What a great website.'
    click_button 'Send'
    page.body.should have_content("is invalid")
  end

  it "does not deliver a message with a blank email" do
    visit new_email_path
    fill_in 'Name', with: 'Sam Rayner'
    fill_in 'Message', with: 'What a great website.'
    click_button 'Send'
    page.body.should have_content("can't be blank")
  end

  it "does not deliver a message with a blank message" do
    visit new_email_path
    fill_in 'Name', with: 'Sam Rayner'
    fill_in 'Email', with: 'sam@example.com'
    click_button 'Send'
    page.body.should have_content("can't be blank")
  end

  it "does not deliver spam" do
    visit new_email_path
    fill_in 'Name', with: 'Sam Rayner'
    fill_in 'Email', with: 'spammer@spammyjunk.com'
    fill_in 'Message', with: "All the junk you'll never need."
    fill_in 'First name', with: 'Want to buy some gold?'
    click_button 'Send'
    page.body.should have_content('must be blank')
  end
end
