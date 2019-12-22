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

      # it 'returns 200 status' do
      #   expect(response).to be_successful
      # end

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
    let!(:question) { create(:question, :with_attached_file) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let(:first_comment) { question.comments.first }
      let(:first_response_comment) { question_response['comments'].find{|c| c['id'] == first_comment.id} }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let(:first_link) { links.first }
      let(:first_response_link) { question_response['links'].find{|c| c['id'] == first_link.id} }
      let!(:files) { question.files }
      let(:first_response_file) { question_response['files'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      context 'comments' do
        it "returns all question's comments" do
          expect(question_response['comments'].size).to eq question.comments.size
        end

        it "return's comment public fields" do
          %w[id body created_at updated_at user_id].each do |attr|
            expect(first_response_comment[attr]).to eq first_comment.send(attr).as_json
          end
        end

        # it 'contains user' do
        #   expect(first_response_comment).to have_key('user')
        # end
      end

      context 'links' do
        it "returns all question's links" do
          expect(question_response['links'].size).to eq question.links.size
        end

        it "return's link public fields" do
          %w[id name url created_at updated_at].each do |attr|
            expect(first_response_link[attr]).to eq first_link.send(attr).as_json
          end
        end
      end

      context 'files' do
        it "returns all question's files" do
          expect(question_response['files'].size).to eq question.files.size
        end

        it 'returns url' do
          expect(first_response_file).to have_key('url')
        end
      end
    end
  end
end