require "spec_helper"

describe "Users" do
  describe "Signing Up" do
    before do
      FactoryGirl.create(:company, :name => "Viget Labs")
      visit "/users/new"
    end

    describe "with valid user information" do

      it "creates a user record when selecting a company" do
        fill_in_sign_up_form_with("lawson.kurtz@viget.com")
        select "Viget Labs", :from => "Company"

        expect { click_button "Sign Up" }.to change { User.count }.by(1)
        User.find_by_email("lawson.kurtz@viget.com").should_not be_nil
        page.should have_content("User created")
      end

      it "creates a company record and assign it the the user when entering a company name which", :js => true do
        fill_in_sign_up_form_with("john.smith@viget.com")
        click_link "Add a New Company"
        fill_in "user_company_attributes_name", :with => "Acme, Inc."

        expect { click_button "Sign Up" }.to change { Company.count }.by(1)
        Company.last.id.should == User.find_by_email("john.smith@viget.com").company_id
      end
    end

    describe "with no user information" do
      it "does not create a user record" do
        expect { click_button "Sign Up" }.to_not change { User.count }
        page.should have_content("There were errors in your submission")
      end
    end

    describe "with invalid user information" do
      it "does not create a user record" do
        fill_in_sign_up_form_with("lawson.kurtz@viget")
        select "Viget Labs", :from => "Company"

        expect { click_button "Sign Up" }.to_not change { User.count }
        page.should have_content("There were errors in your submission")
      end
    end

    def fill_in_sign_up_form_with(email)
      fill_in "user_first_name", :with => "Lawson"
      fill_in "user_last_name",  :with => "Kurtz"
      fill_in "user_email", :with => email
      fill_in "user_password", :with => "password"
      fill_in "user_password_confirmation", :with => "password"
    end
  end  
end