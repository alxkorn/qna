require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'creates association with user (creator)' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }

        expect(assigns(:comment).user).to eq user
      end

      it 'creates association with commentable' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
        expect(assigns(:comment).commentable).to eq question
      end

      it 'saves comment in datadase' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js } }.to change(question.comments, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in datadase' do
        expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), format: :js } }.to_not change(Comment, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end
end
