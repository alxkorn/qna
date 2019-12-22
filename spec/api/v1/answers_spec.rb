# frozen_string_literal: true

require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end

  describe 'GET /api/v1/questions/:question_id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { api_v1_question_answers_path(question) }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:first_answer) { answers.first }
      let(:answer_response) { json['answers'].find{|a| a['id'] == first_answer.id} }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it "returns list of question's answers" do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at user_id].each do |attr|
          expect(answer_response[attr]).to eq first_answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:resource) { create(:answer, :with_attached_file) }
    let(:api_path) { api_v1_answer_path(resource) }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns all public fields' do
        get api_path, params: { access_token: access_token.token }, headers: headers

        %w[id body created_at updated_at user_id].each do |attr|
          expect(json['answer'][attr]).to eq resource.send(attr).as_json
        end
      end

      it_behaves_like 'API Commentable'
      it_behaves_like 'API Linkable'
      it_behaves_like 'API Attachable'
    end
  end
end