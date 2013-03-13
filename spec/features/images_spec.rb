require "spec_helper"

describe "Images" do
  context "when logged in" do
    let(:user) { create(:user_with_images, :first_name => "First", :last_name => "Last") }
    before do
      log_in user.email, user.password
    end

    describe "submitting new image form" do
      let(:image) { build(:image) }
      before { visit "/#{user.company_slug}" }
      
      context "when providing a valid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','images','example.png')
          click_button "Add it!"
        end

        it "creates a new image" do
          current_path.should eql(company_images_path(:company_slug => user.company_slug))
          page.should have_content "Image saved."
        end
      end

      context "when providing an invalid file" do
        before do
          attach_file "image_file", Rails.root.join('spec','fixtures','files','example.pdf')
          click_button "Add it!"
        end

        it "re-renders the add image form with errors" do
          current_path.should eql(company_images_path(:company_slug => user.company_slug))
          page.should have_content "There were errors with your submission"
        end
      end
    end

    describe "viewing image feed" do
      context "for a company" do
        context "for the wrong company" do
          before { visit "/wrong-company" }

          it "redirects to the proper company feed url" do
            current_path.should eql("/#{user.company.slug}")
          end
        end

        context "for the correct company" do
          context "when a user has an associated company" do
            context "when the user's company has images" do
              let!(:company_image) { create(:image, :company => user.company) }
              before { visit "/#{user.company.slug}" }

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

                it "contains a small version of the entry image" do
                  should have_xpath("./img[@src=\"#{user.images.first.file_url(:small)}\"]")
                end

                context "if the user has an avatar" do
                  it "has the user's avatar image thumbnail" do
                    should have_xpath(".//img[@src=\"/uploads/user/avatar/#{user.id}/thumb_example.png\"]")
                  end
                end

                context "if the user does not have an avatar" do
                  let(:user) { create(:user_without_avatar) }

                  it "has the fallback avatar image thumbnail" do
                    should have_xpath(".//img[@src=\"/assets/thumb_avatar_fallback.jpeg\"]")
                  end
                end
              end
            end

            context "over 25 images" do
              let(:user) { create(:user_with_images, :images_count => 26) }

              it "displays only 25 images at a time" do
                page.should have_css("ul.images li", :count => 25)
              end

              it "displays pagination link" do
                page.should have_css("nav.pagination a")
              end
            end
          end

          context "when the user's company has no images" do
            let(:user) { create(:user) }
            before { visit "/#(user.company.slug)" }

            it "displays a no images message" do
              page.should have_content "There aren't any images here yet."
            end
          end
        end
      end

      context "for a user" do
        let(:current_user_company) { create(:company, :name => "Coca Cola") }
        let(:current_user) { create(:user, :company => current_user_company) }
        before { log_in current_user.email, current_user.password }

        context "in the current user's company" do
          let(:other_user) { create(:user_with_images, :company => current_user_company) }
          before { visit "/#{other_user.company_slug}/#{other_user.slug}" }

          it "displays that user's image stream" do
            other_user.images.each { |img| page.should have_selector("#image-#{img.id}") }
          end
        end

        context "not in the current user's company" do
          let(:other_user) { create(:user, :company => create(:company, :name => "Pepsi")) }
          before { visit "/#{other_user.company_slug}/#{other_user.slug}" }

          it "redirects to the current user's company image stream" do
            page.current_path.should == company_images_path(:company_slug => current_user.company_slug)
          end
        end
      end
    end
  end

  context "when not logged in" do
    describe "visiting an image stream url" do
      before { visit "/acme-inc" }

      it "redirects to the homepage" do
        page.current_path.should == root_path
        page.should have_content "Please sign in."
      end
    end
  end
end
