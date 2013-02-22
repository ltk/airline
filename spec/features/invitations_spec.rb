require "spec_helper"

describe "Invitations" do
  describe "inviting a person to signup" do
    context "when logged out" do
      it "redirects to the login page" do
        visit "/invitation/new"

        current_path.should == new_session_path
        page.should have_content "You must sign in first"
      end
    end

    context "when logged in" do
      let(:user) { FactoryGirl.create(:user) }
    
      before do
        log_in user.email, user.password
        InvitationMailer.deliveries.clear
      end

      describe "with a valid email address" do
        it "sends new invitation record" do
          invite("bob.loblaw@lawsblog.com")
          expect { click_button "Send Invite" }.to change { Invitation.count }.by(1)
          current_path.should == root_path
          page.should have_content "Invitation sent"
          Invitation.last.company_id.should == user.company_id
          InvitationMailer.deliveries.should_not be_empty
        end
      end

      describe "with an invalid email address" do
        it "re-renders the new invitation page" do
          invite("bob@loblawlawsblog")
          expect { click_button "Send Invite" }.to_not change { Invitation.count }
          page.current_path.should == invitation_path
          page.should have_content "There were errors in your submission"
          InvitationMailer.deliveries.should be_empty
        end
      end
    end
  end

  def invite(email)
    visit new_invitation_path
    fill_in "Email", :with => email
  end
end