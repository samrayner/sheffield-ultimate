class Email < Tableless
  attr_accessor :name, :email, :message, :first_name
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates_presence_of :name
  validates_presence_of :message
  validates_absence_of :first_name

  def submit
    ContactMailer.contact_email(self).deliver
  end
end
