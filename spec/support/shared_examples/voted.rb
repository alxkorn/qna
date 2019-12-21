# frozen_string_literal: true

RSpec.shared_examples 'Voted' do |resource_type|
  let(:user) { create(:user) }

  describe 'POST #upvote' do
    before { login(user) }

    context 'user is allowed to vote' do
      let(:resource) { create(resource_type) }

      it 'creates a new vote' do
        expect { post :upvote, params: { id: resource.id } }.to change(resource.votes, :count).by(1)
      end

      it 'creates a vote with value=1' do
        post :upvote, params: { id: resource.id }
        expect(resource.votes.first.value).to eq 1
      end

      it 'it responds with json' do
        post :upvote, params: { id: resource.id }
        resource.reload
        expected_json = { rating: resource.rating, id: resource.id, type: resource.type }.to_json

        expect(response.body).to include expected_json
      end
    end

    context 'user is not allowed to vote' do
      let(:resource) { create(resource_type, user: user) }

      it 'does not create vote' do
        expect { post :upvote, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'responds with forbidden' do
        post :upvote, params: { id: resource.id, format: :js }

        expect(response.status).to eq 403
      end
    end
  end

  describe 'POST #downvote' do
    before { login(user) }

    context 'user is allowed to vote' do
      let(:resource) { create(resource_type) }

      it 'creates a new vote' do
        expect { post :downvote, params: { id: resource.id } }.to change(resource.votes, :count).by(1)
      end

      it 'creates a vote with value=-1' do
        post :downvote, params: { id: resource.id }

        expect(resource.votes.first.value).to eq(-1)
      end

      it 'it responds with json' do
        post :downvote, params: { id: resource.id }
        resource.reload
        expected_json = { rating: resource.rating, id: resource.id, type: resource.type }.to_json

        expect(response.body).to include expected_json
      end
    end

    context 'user is not allowed to vote' do
      let(:resource) { create(resource_type, user: user) }

      it 'does not create vote' do
        expect { post :downvote, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'responds with forbidden' do
        post :downvote, params: { id: resource.id, format: :js }

        expect(response.status).to eq 403
      end
    end
  end

  describe 'DELETE #cancel_vote' do
    before { login(user) }

    context 'user is allowed to cancel vote' do
      let(:resource) { create(resource_type) }
      let!(:vote) { create(:vote, user: user, value: 1, votable: resource) }

      it 'deletes vote' do
        expect { delete :cancel_vote, params: { id: resource.id } }.to change(resource.votes, :count).by(-1)
      end

      it 'it responds with json' do
        delete :cancel_vote, params: { id: resource.id }
        resource.reload
        expected_json = { rating: resource.rating, id: resource.id, type: resource.type }.to_json

        expect(response.body).to include expected_json
      end
    end

    context 'user is not allowed to cancel vote' do
      let(:resource) { create(resource_type, user: user) }

      it 'does not delete vote' do
        expect { delete :cancel_vote, params: { id: resource.id } }.to_not change(resource.votes, :count)
      end

      it 'responds with forbidden' do
        delete :cancel_vote, params: { id: resource.id, format: :js }

        expect(response.status).to eq 403
      end
    end
  end
end
