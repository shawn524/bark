require 'rails_helper'

RSpec.describe DogsController, type: :controller do
  describe '#index' do
    it 'displays recent dogs' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = create :user
      sign_in @user
      current_user = subject.current_user

      2.times { create(:dog) }
      get :index
      expect(assigns(:dogs).size).to eq(2)
    end
  end
end
