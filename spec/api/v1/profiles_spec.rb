# frozen_string_literal: true

require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
      let(:req_options) { { params: { access_token: create(:access_token).token }, headers: headers } }
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:profile_response) { json['user'] }

      before do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
      end

      # it 'returns 200 status' do
      #   expect(response).to be_successful
      # end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(profile_response[attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(profile_response).to_not have_key(attr)
        end
      end
    end
  end

  describe 'GET /api/v1/profiles/exceptme' do
    let(:api_path) { '/api/v1/profiles/exceptme' }

    it_behaves_like 'API Authorizable' do
      let(:req_options) { { params: { access_token: create(:access_token).token }, headers: headers } }
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:me) { create(:user) }
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:first_user) { users.first }
      let(:first_response) { json['users'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      # it 'returns 200 status' do
      #   expect(response).to be_successful
      # end

      it 'returns profiles of all users but current' do
        expect(json['users'].size).to eq 3

        ids = json['users'].map { |u| u['id'] }

        expect(ids).to_not include(me.id)
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(first_response[attr]).to eq first_user.send(attr).as_json
        end
      end

      it 'does not return private fields' do
        %w[password encrypted_password].each do |attr|
          expect(first_response).to_not have_key(attr)
        end
      end
    end
  end

end
