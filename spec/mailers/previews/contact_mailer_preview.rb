class ContactMailerPreview < ActionMailer::Preview
  def contact
    email = FactoryGirl.build(:email)
    ContactMailer.contact(email)
  end
end
