# frozen_string_literal: true

require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    it_behaves_like 'API Authorizable' do
      let(:req_options) { { params: { access_token: create(:access_token).token }, headers: headers } }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:resource) { create(:question, :with_attached_file) }
    let(:api_path) { "/api/v1/questions/#{resource.id}" }
    it_behaves_like 'API Authorizable' do
      let(:req_options) { { params: { access_token: create(:access_token).token }, headers: headers } }
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns all public fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers

        %w[id title body created_at updated_at].each do |attr|
          expect(json['question'][attr]).to eq resource.send(attr).as_json
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Linkable'
      it_behaves_like 'API Attachable'
    end
  end

  describe 'POST /api/v1/questions' do
    let(:api_path) { api_v1_questions_path }
    let(:headers) { {'ACCEPT' => 'application/json'} }

    it_behaves_like 'API Authorizable' do
      let!(:req_options) { { params: { access_token: create(:access_token).token, question: attributes_for(:question)}, headers: headers } }
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'creates new question and returns it if params are valid' do
        expect do
          post api_path, params: {access_token: access_token.token, question: {title: 'API test', body: 'API body'}}, headers: headers
        end.to change(Question, :count).by(1)

        expect(json['question']['title']).to eq 'API test'
      end

      it 'does not create question and returns bad request if parameters are invalid' do
        expect do
          post api_path, params: {access_token: access_token.token, question: attributes_for(:question, :invalid)}, headers: headers
        end.to_not change(Question, :count)

        expect(response).to_not be_successful
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let!(:req_options) { { params: { access_token: create(:access_token, resource_owner_id: question.user.id).token, question: attributes_for(:question)}, headers: headers } }
      let(:method) { :put }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: question.user.id) }

      it 'updates question and returns it if params are valid' do
        put api_path, params: {access_token: access_token.token, question: {title: 'API test edited', body: 'API body'}}, headers: headers

        expect(json['question']['title']).to eq 'API test edited'
      end

      it 'does change question and returns bad request if parameters are invalid' do
        expect do
          put api_path, params: {access_token: access_token.token, question: {title: '', body: 'API body'}}, headers: headers
          question.reload
        end.to_not change(question, :title)

        expect(response).to_not be_successful
      end
    end
  end


  describe 'DELETE /api/v1/questions/:id' do
    let(:question) { create(:question) }
    let(:api_path) { api_v1_question_path(question) }
    let(:headers) { { 'ACCEPT' => 'application/json' } }

    it_behaves_like 'API Authorizable' do
      let!(:req_options) { { params: { access_token: create(:access_token, resource_owner_id: question.user.id).token, question: attributes_for(:question)}, headers: headers } }
      let(:method) { :delete }
    end
  end
end