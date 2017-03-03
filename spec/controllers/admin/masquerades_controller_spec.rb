# frozen_string_literal: true
require "rails_helper"

describe Admin::MasqueradesController, "#show" do
  context "as an admin" do
    it "redirects to repos as the maqueraded user" do
      admin = create(:user)
      user = create(:user)
      stub_const("Hound::ADMIN_GITHUB_USERNAMES", [admin.username])
      stub_sign_in(admin)

      get :show, params: { username: user.username }

      expect(session[:masqueraded_user_id]).to eq(user.id)
      expect(session[:remember_token]).to eq(admin.remember_token)
      expect(response).to redirect_to(repos_path)
    end
  end

  context "as a non-admin user" do
    it "redirect to the root without masquerading" do
      non_admin = create(:user)
      user = create(:user)
      stub_sign_in(non_admin)

      get :show, params: { username: user.username }

      expect(response).to redirect_to(root_path)
      expect(session[:masqueraded_user_id]).to be_nil
      expect(session[:remember_token]).to eq(non_admin.remember_token)
    end
  end
end
