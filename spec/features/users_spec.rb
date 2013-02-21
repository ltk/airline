require "spec_helper"

describe "Users" do
  describe "Signing Up" do
    describe "with valid user information" do
      it "creates a user record" do
        visit "/users/new"

        fill_in "user_first_name", :with => "Lawson"
        fill_in "user_last_name",  :with => "Kurtz"
        fill_in "user_company_name",  :with => "Viget Labs"
        fill_in "user_email",
          :with => "lawson.kurtz@viget.com"
        fill_in "user_password", :with => "password"
        fill_in "user_password_confirmation", :with => "password"

        expect { click_button "Sign Up" }.to change { User.count }.by(1)

        User.find_by_email("lawson.kurtz@viget.com").should_not be_nil
        
        page.should have_content("User created")
      end
    end

    describe "with invalid user information" do
      it "does not create a user record" do
        visit "/users/new"

        expect { click_button "Sign Up" }.to_not change { User.count }

        page.should have_content("There were errors in your submission")
      end
    end
  end  
end