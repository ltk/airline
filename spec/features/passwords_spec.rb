require "spec_helper"

describe "Passwords" do
  let(:user) { FactoryGirl.create(:user) }

  describe "Requesting reset instruction delivery" do
    before do
      PasswordResetMailer.deliveries.clear
      visit "/session/new/"
      click_link "Forgot password?"
    end

    context "when providing an existing email address" do
      before { fill_in_password_reset_form_with(user.email) }

      it "sends an email" do
        PasswordResetMailer.deliveries.should_not be_empty
      end

      it "redirects to the homepage with notice" do
        current_path.should eql(root_path)
        page.should have_content "A password reset email has been sent."
      end
    end

    context "when providing a non-existant email address" do
      before { fill_in_password_reset_form_with("non-existant@email.address") }

      it "re-renders the form with errors" do
        current_path.should eql(new_password_path)
        page.should have_content "We couldn't find a user with that email address."
      end

      it "does not send an email" do
        PasswordResetMailer.deliveries.should be_empty
      end
    end
  end

  describe "Following the reset link" do
    before { request_password_reset_for(user) }

    context "with a valid token" do
      before { visit "/user/password/edit/#{user.password_reset_token}" }

      it "renders the reset password form" do
        current_path.should eql(pretty_edit_user_password_path(:token => user.password_reset_token))
        page.should have_content "Reset Your Password"
      end
    end

    context "with an invalid token" do
      before { visit "/user/password/edit/invalid-token" }

      it "redirects to the password reset request page" do
        current_path.should eql(new_password_path)
        page.should have_content "Invalid reset token"
      end
    end
  end

  describe "Submitting reset form" do
    let(:initial_crypt_password) { user.crypted_password }
    before do
      request_password_reset_for(user)
      visit "/user/password/edit/#{user.password_reset_token}"
    end

    context "providing matching password and confirmation" do
      before do
        fill_in "user_password", :with => 'new-password'
        fill_in "user_password_confirmation", :with => 'new-password'
        click_button "Save"
      end

      it "changes the password" do
        initial_crypt_password.should_not eql(user.reload.crypted_password)
      end

      it "unsets the password reset token" do
        user.reload.password_reset_token.should be_nil
      end
    end

    context "providing non-matching password and confirmation" do
      before do
        fill_in "user_password", :with => 'new-password'
        fill_in "user_password_confirmation", :with => 'different-new-password'
      end

      it "does not change the password" do
        initial_crypt_password.should eql(user.reload.crypted_password)
      end
    end
  end

  def fill_in_password_reset_form_with(email)
    fill_in "Email", :with => email
    click_button "Request Reset Instructions"
  end

  def request_password_reset_for(user)
    visit "/password/new/"
    fill_in_password_reset_form_with(user.email)
    user.reload
  end
end