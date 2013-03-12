require "spec_helper"

describe "Invitations" do
  describe "inviting a user to signup" do
    context "when logged out" do
      it "redirects to the homepage" do
        visit "/invitation/new"

        current_path.should == root_path
        page.should have_content "Please sign in."
      end
    end

    context "when logged in" do
      let(:user) { create(:user) }
    
      before do
        log_in user.email, user.password
        InvitationMailer.deliveries.clear
      end

      describe "with a valid email address" do
        it "sends new invitation record" do
          invite("bob.loblaw@lawsblog.com")

          expect { form_submission }.to change { Invitation.count }.by(1)
          current_path.should == company_images_path(:company_slug => user.company_slug)
          page.should have_content "Invitation sent"
          Invitation.last.company_id.should == user.company_id
          InvitationMailer.deliveries.should_not be_empty
        end
      end

      describe "with an invalid email address" do
        it "re-renders the new invitation page" do
          invite("bob@loblawlawsblog")

          expect { form_submission }.to_not change { Invitation.count }
          page.current_path.should == invitation_path
          page.should have_content "There were errors in your submission"
          InvitationMailer.deliveries.should be_empty
        end
      end
    end
  end

  def form_submission
    click_button "Send Invite"
  end

  def invite(email)
    visit new_invitation_path
    fill_in "Email", :with => email
  end
end
