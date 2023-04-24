require 'rails_helper'

RSpec.describe ImportedFilesController, type: :controller do
  let(:user) { create(:user) }
  let(:valid_file) { fixture_file_upload('example.csv', 'text/csv') }

  describe 'GET #index' do
    it 'returns a success response' do
      sign_in user
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      sign_in user
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new ImportedFile' do
        sign_in user
        expect {
          post :create, params: { file: valid_file }
        }.to change(ImportedFile, :count).by(1)
      end

      it 'redirects to the root path' do
        sign_in user
        post :create, params: { file: valid_file }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
