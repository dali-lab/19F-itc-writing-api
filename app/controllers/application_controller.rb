class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # All actions in all controllers require logging in first
  before_action :authenticated?, except: [:healthcheck]

  helper_method :current_user, :logged_in?   # Helper methods are available in Views as well

  def healthcheck
    begin
      c = User.count
    rescue => ex
      render plain: "FAIL", status: :internal_server_error and return
    end
    render plain: "OK"
  end

  def email
    # TODO replaceappname - remove once email test is successful
    ExampleMailer.test_email(current_user.id).deliver_later
    redirect_to root_path and return
  end

  protected

  def logged_in?
    return false if session[:netid].blank?
    current_user.present?
  end

  def authenticated?
    unless logged_in?
      session[:return_url]=request.url
      redirect_to("/auth/cas")
      return false
    end
    true
  end

  private
  def current_user
    # If we already have a current_user, don't do anything
    # Otherwise, look it up from the session if the session id is set
    @current_user ||= User.find_by(netid: session[:netid]) if session[:netid]
  end
end
