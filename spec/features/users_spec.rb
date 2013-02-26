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
        it "fills in the user's email address" do
          invitation = FactoryGirl.create(:invitation)
          visit "/users/new?code=#{invitation.code}"
          email_field_value.should == invitation.email
        end
      end

      describe "that is invalid" do
        it "doesn't fill in an email address" do
          visit "/users/new?code=#{'fakecode'*5}"

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
      fill_in "user_first_name",            :with => user.first_name
      fill_in "user_last_name",             :with => user.last_name
      fill_in "user_email",                 :with => user.email
      fill_in "user_password",              :with => user.password
      fill_in "user_password_confirmation", :with => user.password_confirmation
    end
  end

  describe "editing information" do
    context "when logged in as the user being edited" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit "/session/new"
        fill_in "Email", :with => user.email
        fill_in "Password", :with => user.password
        click_button "Sign in"
        visit "/users/#{user.id}/edit"
      end

      context "providing a valid email address" do
        it "can change email address" do
          fill_in "Email", :with => "new@email.address"
          click_button "Update Information"

          current_path.should eql(edit_user_path(user))
          page.should have_content "Information updated"
          user.reload.email.should eql("new@email.address")
        end
      end

      context "providing an invalid email address" do
        before do
          fill_in "Email", :with => "invalid@email"
          click_button "Update Information"
        end

        it "re-renders the edit form with errors" do
          page.should have_content "There were errors"
          current_path.should eql(edit_user_path(user))
        end

        it "does not change the email address" do
          old_email = user.email
          old_email.should eql(user.reload.email)
        end
      end

      context "providing a new password" do
        before { fill_in "user_password", :with => 'new-password' }

        context "with a matching password confirmation" do
          it "should updated the crypted password" do
            fill_in "user_password_confirmation", :with => 'new-password'
            click_button "Update Information"
            old_crypt_pass = user.crypted_password
            old_crypt_pass.should_not eql(user.reload.crypted_password)
          end
        end
      end

    end

    context "when logged in as a different user" do
      let(:editee) { FactoryGirl.create(:user) }
      let(:editor) { FactoryGirl.create(:user) }
      before do
        visit "/session/new"
        fill_in "Email", :with => editor.email
        fill_in "Password", :with => editor.password
        click_button "Sign in"
        visit "/users/#{editee.id}/edit"
      end

      it "redirects to the home page with errors" do
        current_path.should eql(root_path)
        page.should have_content "You don't have permission to edit that user account"
      end
    end
  end
end