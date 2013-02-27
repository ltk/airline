require "spec_helper"

describe "Images" do
  context "when logged out" do
    describe "visiting the new image page" do
      before { visit "/images/new" }
      
      it "should redirect to the new session page" do
        current_path.should eql(new_session_path)
        page.should have_content "You must sign in first"
      end
    end
  end

  context "when logged in" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      log_in user.email, user.password
    end

    describe "submitting new image form" do
      let(:image) { FactoryGirl.build(:image) }
      before { visit "/images/new" }
      
      context "when providing a valid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','images','example.png')
          click_button "Add it!"
        end

        it "should create a new image" do
          current_path.should eql(new_image_path)
          page.should have_content "Image saved."
        end
      end

      context "when providing an invalid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','files','example.pdf')
          click_button "Add it!"
        end

        it "should re-render the add image form with errors" do
          current_path.should eql(new_image_path)
          page.should have_content "There were errors with your submission"
        end
      end
    end
  end
end
