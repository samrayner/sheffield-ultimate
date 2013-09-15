class EmailsController < ApplicationController
  include ApplicationHelper

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
        email = html_obfuscate("info@sheffieldultimate.com")
        flash[:error] = "Sorry, your message could not be delivered. Please email <a href=\"mailto:#{email}\">#{email}</a>.".html_safe
      end
    end

    render cms_page: "/contact"
  end
end
