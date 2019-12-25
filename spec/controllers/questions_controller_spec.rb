# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  it_should_behave_like 'Votable', :question

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'creates new link' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'creates association with user (creator)' do
        post :create, params: { question: attributes_for(:question) }

        expect(assigns(:question).user).to eq user
      end

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end

      it 'attaches files to questions' do
        @file1 = fixture_file_upload('files/test1.png', 'image/png')
        @file2 = fixture_file_upload('files/test2.png', 'image/png')

        post :create, params: { question: attributes_for(:question, files: [@file1, @file2]) }

        expect(assigns(:question).files.count).to eq 2
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    describe 'owned question' do
      let!(:question) { create(:question, :with_attached_file, user: user) }

      context 'with valid attributes' do
        it 'assigns requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }

          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'adds files to answer' do
          @file1 = fixture_file_upload('files/test1.png', 'image/png')
          @file2 = fixture_file_upload('files/test2.png', 'image/png')

          expect do
            patch :update, params: { id: question, question: { files: [@file1, @file2] } }, format: :js
          end.to change(question.files, :count).by(2)
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid), format: :js } }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 'renders update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'not owned question' do
      let!(:question) { create(:question) }

      it 'responds with forbidden' do
        patch :update, params: { id: question, question: { body: 'new body' }, format: :js }

        expect(response.status).to eq 403
      end

      it 'does not change question attributes' do
        expect do
          patch :update, params: { id: question, question: { body: 'new body' }, format: :js }
          question.reload
        end.to_not change(question, :body)
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'owned question' do
      let!(:question) { create(:question, user: user) }
      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not owned question' do
      let!(:question) { create(:question) }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects root url' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'POST #subscribe' do
    let(:question) { create(:question) }
    context 'Unauthorized' do
      context 'guest' do
        it 'does not allow to subscribe' do
          post :subscribe, params: { id: question, format: :js }

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
          post :subscribe, params: { id: question, format: :js }

          expect(response).to_not be_successful
        end
      end
    end
    
    context 'Authorized' do
      let(:user) { create(:user) }
      before do 
        login(user)
        post :subscribe, params: { id: question, format: :js }
      end

      it 'assigns @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders subscribe view' do
        expect(response).to render_template :subscribe
      end
    end
  end


  describe 'DELETE #unsubscribe' do
    let(:question) { create(:question) }
    context 'Unauthorized' do
      context 'guest' do
        it 'does not allow to unsubscribe' do
          delete :unsubscribe, params: { id: question, format: :js }

          expect(response).to_not be_successful
        end
      end

      context 'user' do
        let(:user) { create(:user) }

        before do
          login(user)
        end

        it 'does not allow to subscribe' do
          delete :unsubscribe, params: { id: question, format: :js }

          expect(response).to_not be_successful
        end
      end
    end
    
    context 'Authorized' do
      let(:user) { create(:user) }
      before do 
        login(user)
        question.subscribe(user)
        delete :unsubscribe, params: { id: question, format: :js }
      end

      it 'assigns @question' do
        expect(assigns(:question)).to eq question
      end

      it 'renders unsubscribe view' do
        expect(response).to render_template :unsubscribe
      end
    end
  end
end
