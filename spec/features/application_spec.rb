require 'rails_helper'

describe "when logged in", :type => :feature do

  it "shows home page" do
    user = login_as(:user)
    visit '/'
    expect(page).to have_content 'Signed in as '+user.name
    expect(page).to have_content 'replaceappname'
  end

end
