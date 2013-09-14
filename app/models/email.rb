class Email < MailForm::Base
  attribute :name,  validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :message, validate: true
  attribute :nickname,  captcha: true

  def headers
    {
      subject: "Message From Website Contact Form",
      to: "info@sheffieldultimate.co.uk",
      from: %("#{name}" <#{email}>)
    }
  end
end
