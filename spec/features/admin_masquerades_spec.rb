# frozen_string_literal: true
require "rails_helper"

feature "Admin masquerades as user" do
  scenario "admin sees user repos and can stop masquerading" do
    admin = create(:user, token: "admin")
    repo = create(:repo)
    user = create(:user, repos: [repo], token: "user")
    stub_const("Hound::ADMIN_GITHUB_USERNAMES", [admin.username])

    sign_in_as(admin, "admin")
    visit admin_masquerade_path(user.username)

    expect(current_path).to eq(repos_path)
    within "header .account" do
      expect(page).to have_content(user.username)
    end

    click_on "Stop Masquerading"

    within "header .account" do
      expect(page).to have_content(admin.username)
    end
  end
end
