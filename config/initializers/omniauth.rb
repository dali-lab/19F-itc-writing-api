Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cas,
         :url => "https://login.dartmouth.edu",
         :login_url => "/cas/login",
         :service_validate_url => "/cas/serviceValidate",
         :uid_key =>"user"
end
