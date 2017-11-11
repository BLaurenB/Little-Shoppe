require "rails_helper"

describe "As a logged in Admin" do
  it "I can modify my account data" do

    admin_user = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom", role: "admin")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin_user)

    visit admin_dashboard_index_path
    click_on "Update Account"
    fill_in "user[password]", with: "testing"
    fill_in "user[email]", with: "testerson@testmail.com"

    click_on "Submit"
    expect(admin_user.password).to eq("testing")


  end

    it "But I cannot modify any other user’s account data" do
      user = User.create(first_name: "Tester", last_name: "McTesty", email: "testerson@testmail.com", password: "testing")

      admin_user = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom", role: "admin")

      allow_any_instance_of(ApplicationController).to receive(:current_user). and_return(admin_user)

      visit dashboard_index_path(user)

      expect(page).not_to have_content("Update account")

    end

    it "A visitor sees a 404 when they try to visit the admin dashboard" do
      admin_user = User.create(first_name: "Admin", last_name: "McAdmin", email: "admin@admin.com", password: "boom", role: "admin")
      visit admin_dashboard_index_path
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
