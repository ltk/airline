require "spec_helper"

describe "a user wishing to sign up for an account" do
  describe "when filling out the new user signup form completely on /users/new" do
    it "creates a user record" do
      visit "/users/new"

      fill_in "user_first_name", :with => "Lawson"
      fill_in "user_last_name",  :with => "Kurtz"
      fill_in "user_email",
        :with => "lawson.kurtz@viget.com"
      fill_in "user_password", :with => "password"
      fill_in "user_password_confirmation", :with => "password"

      click_button "Sign Up"

      User.find_by_email("lawson.kurtz@viget.com").should_not be_nil
      
      page.should have_content("User created")
      # page.should flash_with "User created"
      # flash[:notice].should == "User created"
    end
  end

  describe "when filling out the new user signup form incorrectly on /users/new" do
    it "does not create a user record" do
      visit "/users/new"
      click_button "Sign Up"

      page.should have_content("There were errors in your submission")
      # page.should flash_with "There were errors in your submission"
      # flash[:alert].should == "There were errors in your submission"
    end
  end
end
