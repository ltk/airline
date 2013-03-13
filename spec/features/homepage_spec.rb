require "spec_helper"

describe "Homepage" do
  context "when logged out" do
    describe "visiting the root url" do
      before { visit "/" }

      it "displays a welcome message" do
        page.should have_content "Welcome to Airline"
      end

      it "displays a sign in form" do
        page.should have_xpath("//form[@action='#{session_path}' and @method='post']")
      end
    end
  end

  context "when logged in" do
    describe "visiting the root url" do
      let(:user) { create(:user) }
      before do
        log_in user.email, user.password
        visit "/"
      end

      it "redirects to the user's company image stream" do
        page.current_path.should == company_images_path(:company_slug => user.company_slug)
      end
    end
  end
end