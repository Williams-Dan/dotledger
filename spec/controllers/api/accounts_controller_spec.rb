require 'rails_helper'

describe Api::AccountsController do
  let!(:account) { FactoryBot.create :account, name: 'Account Name' }
  let!(:archived_account) { FactoryBot.create :account, name: 'Old Account', archived: true }

  describe 'GET index' do
    context 'no filters' do
      before { get :index }

      it { should respond_with :success }

      it 'returns active accounts' do
        expect(assigns(:accounts)).to eq [account]
      end
    end
    
    context 'filter archived' do
      before { get :index, params: { archived: true } }

      it { should respond_with :success }

      it 'returns archived accounts' do
        expect(assigns(:accounts)).to eq [archived_account]
      end
    end
  end

  describe 'GET show' do
    before { get :show, params: { id: account.id } }

    it { should respond_with :success }

    it 'returns the account' do
      expect(assigns(:account)).to eq account
    end
  end

  describe 'POST create' do
    def valid_request
      post :create, params: {
        name: 'Account Name',
        number: '1212341234567120',
        type: 'Cheque',
        account_group_id: 2,
        archived: false
      }
    end

    it 'responds with 200' do
      valid_request
      expect(subject).to respond_with(:success)
    end

    it 'creates an account' do
      expect do
        valid_request
      end.to change(Account, :count).by(1)
    end
  end

  describe 'PUT update' do
    def valid_request
      put :update, params: { id: account.id, name: 'New Account Name' }
    end

    it 'responds with 200' do
      valid_request
      expect(subject).to respond_with(:success)
    end

    it 'updates the name' do
      expect do
        valid_request
      end.to change { account.reload.name }.from('Account Name').to('New Account Name')
    end
  end

  describe 'DELETE destroy' do
    def valid_request
      delete :destroy, params: { id: account.id }
    end

    it 'responds with 204' do
      valid_request
      expect(subject).to respond_with(:no_content)
    end

    it 'deletes the account' do
      expect do
        valid_request
      end.to change(Account, :count).by(-1)
    end
  end
end
