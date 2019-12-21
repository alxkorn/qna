# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  it_should_behave_like 'Voted', :answer

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'creates association with user (creator)' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }

        expect(assigns(:answer).user).to eq user
      end

      it 'attaches files to answer' do
        @file1 = fixture_file_upload('files/test1.png', 'image/png')
        @file2 = fixture_file_upload('files/test2.png', 'image/png')

        post :create, params: { question_id: question, answer: attributes_for(:answer, files: [@file1, @file2]), format: :js }

        expect(assigns(:answer).files.count).to eq 2
      end

      it 'assigns requested question to @question' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(assigns(:question)).to eq question
      end

      it 'saves answer in datadase' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer in datadase' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js } }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'owned answer' do
      let!(:answer) { create(:answer, user: user) }
      it 'deletes the question' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'not owned answer' do
      let!(:answer) { create(:answer) }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: answer, format: :js } }.to_not change(Answer, :count)
      end

      it 'responds with forbidden' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response.status).to eq 403
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'owned answer' do
      let!(:answer) { create(:answer, :with_attached_file, question: question, user: user ) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'adds files to answer' do
          @file1 = fixture_file_upload('files/test1.png', 'image/png')
          @file2 = fixture_file_upload('files/test2.png', 'image/png')

          expect do
            patch :update, params: { id: answer, answer: { files: [@file1, @file2] } }, format: :js
          end.to change(answer.files, :count).by(2)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
            answer.reload
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid), format: :js }
          expect(response).to render_template :update
        end
      end
    end

    context 'not owned answer' do
      let!(:answer) { create(:answer) }

      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
          answer.reload
        end.to_not change(answer, :body)
      end

      it 'responds with forbidden' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js

        expect(response.status).to eq 403
      end
    end
  end

  describe 'PATCH #set_best' do
    let!(:question) { create(:question, user: user) }
    let!(:answer1) { create(:answer, question: question, best: false) }
    let!(:answer2) { create(:answer, question: question, best: true) }

    context "user is the author of answer's question" do
      before do
        login(user)
        patch :set_best, params: { id: answer1, format: :js }
        answer1.reload
        answer2.reload
      end

      it "sets chosen answer's best attribute to true" do
        expect(answer1.best).to eq true
      end

      it "sets other answers' best attribute to false (within given question)" do
        expect(answer2.best).to eq false
      end

      it 'renders set_best view' do
        expect(response).to render_template :set_best
      end

    end

    context "user is not the author of answer's question" do
      let(:user_not_author) { create(:user) }

      before { login(user_not_author) }

      it "does not set chosen answer's best attribute to true" do
        expect do
          patch :set_best, params: { id: answer1, format: :js }
          answer1.reload
          answer2.reload
        end.to_not change(answer1, :best)
      end

      it "does not set other answers' best attribute to false (within given question)" do
        expect do
          patch :set_best, params: { id: answer1, format: :js }
          answer1.reload
          answer2.reload
        end.to_not change(answer2, :best)
      end

      it 'responds with forbidden' do
        patch :set_best, params: { id: answer1, format: :js }

        expect(response.status).to eq 403
      end
    end
  end
end
