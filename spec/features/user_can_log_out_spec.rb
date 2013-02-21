require "spec_helper"

describe "a user who is logged in" do
  it "should be able to log out" do
    user = FactoryGirl.create(:user)
    log_in user

    visit root_path
    click_link "Sign Out"

    page.current_path.should == new_session_path
  end
end
