require "spec_helper"

describe "Users" do
  describe "Signing up" do
    let(:user) { FactoryGirl.build(:user) }
    context "without an invitation code" do
      before do
        FactoryGirl.create(:company, :name => "Viget Labs")
        visit "/users/new"
      end

      describe "with valid user information" do
        it "creates a user record when selecting a company" do
          fill_in_sign_up_form_with(user)
          select "Viget Labs", :from => "Company"

          expect { form_submission }.to change { User.count }.by(1)
          User.find_by_email(user.email).should_not be_nil
          page.should have_content("User created")
        end

        it "creates a company record and assigns it the the user when entering a company name", :js => true do
          fill_in_sign_up_form_with(user)
          click_link "Add a New Company"
          fill_in "user_company_attributes_name", :with => "Acme, Inc."

          expect { form_submission }.to change { Company.count }.by(1)
          Company.last.id.should == User.find_by_email(user.email).company_id
        end
      end

      describe "with no user information" do
        it "does not create a user record" do
          expect { form_submission }.to change { User.count }.by(0)
          page.should have_content("There were errors in your submission")
        end
      end

      describe "with invalid user information" do
        let(:invalid_user) { FactoryGirl.build(:user, :email => 'invalid@email') }
        it "does not create a user record" do
          fill_in_sign_up_form_with(invalid_user)
          select "Viget Labs", :from => "Company"

          expect { form_submission }.to change { User.count }.by(0)
          page.should have_content("There were errors in your submission")
        end
      end
    end

    context "with an invitation code" do
      describe "that is valid" do
        it "should fill in the user's email address" do
          invitation = FactoryGirl.create(:invitation)
          visit "/users/new/#{invitation.code}"
          email_field_value.should == invitation.email
        end
      end

      describe "that is invalid" do
        it "should not fill in an email address" do
          visit "/users/new/#{'fakecode'*5}"

          email_field_value.should be_blank
        end
      end
    end

    def email_field_value
      find_field("Email").value
    end

    def form_submission
      click_button "Sign Up"
    end

    def fill_in_sign_up_form_with(user)
      fill_in "user_first_name", :with => user.first_name
      fill_in "user_last_name",  :with => user.last_name
      fill_in "user_email", :with => user.email
      fill_in "user_password", :with => user.password
      fill_in "user_password_confirmation", :with => user.password_confirmation
    end
  end  
end