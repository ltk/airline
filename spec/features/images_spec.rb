require "spec_helper"

describe "Images" do
  context "when logged in" do
    let(:user) { FactoryGirl.create(:user_with_images, :first_name => "First", :last_name => "Last") }
    before do
      log_in user.email, user.password
    end

    describe "submitting new image form" do
      let(:image) { FactoryGirl.build(:image) }
      before { visit "/" }
      
      context "when providing a valid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','images','example.png')
          click_button "Add it!"
        end

        it "creates a new image" do
          current_path.should eql(root_path)
          page.should have_content "Image saved."
        end
      end

      context "when providing an invalid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','files','example.pdf')
          click_button "Add it!"
        end

        it "re-renders the add image form with errors" do
          current_path.should eql(root_path)
          page.should have_content "There were errors with your submission"
        end
      end
    end

    describe "viewing the homepage" do
      context "when a user has an associated company" do
        context "when the user's company has images" do
          let!(:company_image) { FactoryGirl.create(:image, :company => user.company) }
          before { visit "/" }

          it "displays a list of image entries" do
            company_images = user.images.push(company_image)
            company_images.each { |img| page.should have_selector("#image-#{img.id}") }
          end

          describe "each image entry" do
            subject { find("#image-#{user.images.first.id}") }

            it "has a human-readable timestamp" do
              should have_content("less than a minute ago")
            end

            it "has the user's name" do
              should have_content("First Last")
            end

            it "has an image" do
              should have_xpath("./img")
            end

            context "if the user has an avatar" do
              it "has the user's avatar image thumbnail" do
                should have_xpath(".//img[@src=\"/uploads/user/avatar/#{user.id}/thumb_example.png\"]")
              end
            end

            context "if the user does not have an avatar" do
              let(:user) { FactoryGirl.create(:user_without_avatar) }

              it "has the fallback avatar image thumbnail" do
                should have_xpath(".//img[@src=\"/assets/thumb_avatar_fallback.jpeg\"]")
              end
            end
          end

          context "over 25 images" do
            let(:user) { FactoryGirl.create(:user_with_images, :images_count => 26) }

            it "displays only 25 images at a time" do
              page.should have_css("ul.images li", :count => 25)
            end

            it "displays pagination link" do
              page.should have_css("nav.pagination a")
            end
          end
        end

        context "when the user's company has no images" do
          let(:user) { FactoryGirl.create(:user) }
          before { visit "/" }

          it "displays a no images message" do
            page.should have_content "There aren't any images here yet."
          end
        end
      end

      context "when a user does not have an associated company" do
        context "when the user has no images" do
          let(:user) { FactoryGirl.create(:user, :company_id => nil) }

          it "should display a no images message" do
            page.should have_content "There aren't any images here yet."
          end
        end

        context "when the user has images" do
          let(:user) { FactoryGirl.create(:user_with_images, :company_id => nil) }

          it "should display a list of images" do
            user.images.each { |img| page.should have_selector("#image-#{img.id}") }
          end
        end
      end
    end
  end
end
