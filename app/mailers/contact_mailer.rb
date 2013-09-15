class ContactMailer < ActionMailer::Base
  default to: "info@sheffieldultimate.co.uk",
          subject: "Message From Website Contact Form"

  def contact_email(email)
    @name = email.name
    @email = email.email
    @message = email.message
    from = "#{@name} <#{@email}>"
    mail(from: from, reply_to: from)
  end
end
