class EmailsController < ApplicationController
  def new
    @email = Email.new
    render cms_page: "/contact"
  end

  def create
    @email = Email.new(params[:email])
    @email.request = request

    if @email.deliver
      flash[:success] = "Thank you for your message. We'll respond as soon as we can."
      redirect_to(new_email_path)
    else
      if @email.errors.keys.empty?
        flash.now[:error] = "Sorry, your email could not be delivered."
      end
      render cms_page: "/contact"
    end
  end
end
