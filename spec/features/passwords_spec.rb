require "spec_helper"

describe "Passwords" do
  describe "Requesting reset instruction delivery" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      PasswordResetMailer.deliveries.clear
      visit "/password/new/"
    end

    context "when providing an existing email address" do
      before { fill_in_form_with user.email }

      it "sends an email" do
        PasswordResetMailer.deliveries.should_not be_empty
      end

      it "redirects to the homepage with notice" do
        current_path.should eql(root_path)
        page.should have_content "A password reset email has been sent."
      end
    end

    context "when providing a non-existant email address" do
      before { fill_in_form_with "non-existant@email.address" }

      it "re-renders the form with errors" do
        current_path.should eql(new_password_path)
        page.should have_content "We couldn't find a user with that email address."
      end

      it "does not send an email" do
        PasswordResetMailer.deliveries.should be_empty
      end
    end

    def fill_in_form_with(email)
      fill_in "Email", :with => email
      click_button "Request Reset Instructions"
    end
  end
end