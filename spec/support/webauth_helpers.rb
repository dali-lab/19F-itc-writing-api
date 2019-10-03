module WebauthHelpers

  def login_as(factory, opts={})
    user = create(factory, opts)
    OmniAuth.config.mock_auth[:cas] = OmniAuth::AuthHash.new({
      :provider => :cas,
      :uid => user.email,
      :extra => {:uid=>user.netid, :netid=>user.netid},
      :info => {:name=>user.name}
    })
    visit("/auth/cas")
    user
  end

  def login_as_user(user)
    OmniAuth.config.mock_auth[:cas] = OmniAuth::AuthHash.new({
      :provider => :cas,
      :uid => user.email,
      :extra => {:uid=>user.netid, :netid=>user.netid},
      :info => {:name=>user.name}
    })
    visit("/auth/cas")
    user
  end

end

RSpec.configure do |config|
  config.include(WebauthHelpers)
end
