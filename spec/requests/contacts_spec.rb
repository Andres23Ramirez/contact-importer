require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe "GET #index" do
    context "when user is authenticated" do
      let(:user) { create(:user) }
      before { sign_in user, scope: :user }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
      end
    end

    context "when user is not authenticated" do
      it "redirects to login page" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
