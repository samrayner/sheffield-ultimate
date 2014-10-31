require "valid_email/email_validator"

class Email < Tableless
  attr_accessor :name, :email, :message, :first_name
  validates :email, presence: true, email: true
  validates_presence_of :name
  validates_presence_of :message
  validates_absence_of :first_name

  def submit
    ContactMailer.contact(self).deliver
  end
end
