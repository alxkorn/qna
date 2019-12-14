require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question1) { create(:question) }
  let(:question2) { create(:question) }
  let!(:reward1) { create(:reward, :with_image, question: question1, user: user) }
  let!(:reward2) { create(:reward, :with_image, question: question2, user: user) }

  describe 'GET #index' do
    before do
      login(user)
      get :index
    end

    it 'assigns rewards to @rewards' do
      expect(assigns(:rewards)).to eq [reward1, reward2]
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
