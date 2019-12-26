require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    context 'Unauthorized' do
      context 'guest' do
        it 'does not allow to subscribe' do
          post :create, params: { question_id: question, format: :js }

          expect(response).to_not be_successful
        end
      end

      context 'user' do
        let(:user) { create(:user) }

        before do
          question.subscribe(user)
          login(user)
        end

        it 'does not allow to subscribe' do
          post :create, params: { question_id: question, format: :js }

          expect(response).to_not be_successful
        end
      end
    end
    
    context 'Authorized' do
      let(:user) { create(:user) }
      before do 
        login(user)
      end

      it 'assigns @question' do
        post :create, params: { question_id: question, format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'creates subscription' do
        expect do
          post :create, params: { question_id: question, format: :js }
        end.to change(question.subscriptions, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end


  describe 'DELETE #unsubscribe' do
    let(:question) { create(:question) }    
    context 'Authorized' do
      let(:user) { create(:user) }
      let!(:subscription) { create(:subscription, user: user, question: question) }
      before do 
        login(user)
      end

      it 'deletes subscription' do
        expect do
          delete :destroy, params: { question_id: question,  id: subscription, format: :js }
          question.reload
        end.to change(question.subscriptions, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { question_id: question,  id: subscription, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
