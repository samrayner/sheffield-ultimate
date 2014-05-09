class EmailsController < ApplicationController
  def new
    @email = Email.new
    render cms_page: "/contact"
  end

  def create
    @email = Email.new(params[:email])

    if @email.valid?
      if @email.submit
        flash[:success] = "Thank you for your message. We'll respond as soon as we can."
        return redirect_to(new_email_path)
      else
        flash[:error] = "Sorry, your message could not be delivered."
      end
    end

    render cms_page: "/contact"
  end
end
