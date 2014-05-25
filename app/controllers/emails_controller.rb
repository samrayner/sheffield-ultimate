class EmailsController < ApplicationController
  def new
    @contact_email = Email.new
    @subscription_email = Email.new
    render cms_page: "/contact"
  end

  def create
    @contact_email = Email.new(params[:email])
    @subscription_email = Email.new

    success = "Thank you for your message. We'll respond as soon as we can."
    failure = "Sorry, your message could not be delivered."
    send_email(@contact_email, success, failure)
  end

  def subscribe
    @contact_email = Email.new
    @subscription_email = Email.new(params[:subscription_email])

    success = "Thank you for subscribing. You'll soon receive updates from the club via email."
    failure = "Sorry, there was a problem subscribing."
    send_email(@subscription_email, success, failure)
  end

  private

  def send_email(email, success, failure)
    if email.valid?
      if email.submit
        flash[:success] = success
        return redirect_to(contact_path)
      else
        flash[:error] = failure
      end
    end

    render cms_page: "/contact"
  end
end
