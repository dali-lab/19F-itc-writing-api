class SessionsController < ApplicationController
  skip_before_action :authenticated? # Don't need to be logged in to see the login / logout pages

  def create
    session[:enable_admin_pages] = false
    user = User.find_by(netid: auth_hash['extra']['netid'])
    if user
      session[:netid] = user.netid
      flash[:success] = "Signed in as #{user.name}"

      # Check auth for admin paths - in this case they have a user record, so set true
      # In other apps further permissions can be checked e.g. admin user type
      session[:enable_admin_pages] = true

      redirect_to session[:return_url] || root_path
    else
      redirect_to not_authorized_path
    end
  end

  def destroy
    app = "replaceappname"
    url = case Rails.env
    when 'dev' then "https://#{app}-dev.dartmouth.edu/"
    when 'preprod' then  "https://#{app}-preprod.dartmouth.edu/"
    when 'production' then "https://#{app}.dartmouth.edu/"
          else
            root_url
          end
    reset_session # Dump all stored session hashes incl. netid
    redirect_to "https://login.dartmouth.edu/logout.php?app=#{app}&url=#{url}"
  end

  def not_authorized
    render plain: "You do not have access to this functionality"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end

end
