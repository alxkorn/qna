RSpec.shared_examples 'Votable' do |resource_type|

  let!(:user) { create(:user) }
  let!(:resource) { create(resource_type) }

  describe 'upvote' do
    it 'creates vote by given user' do
      resource.upvote_by(user)
      expect(resource.votes.first.user).to eq user
    end

    it 'creates vote with value=1' do
      resource.upvote_by(user)
      expect(resource.votes.first.value).to eq 1
    end
  end

  describe 'downvote' do
    it 'creates vote by given user' do
      resource.downvote_by(user)
      expect(resource.votes.first.user).to eq user
    end

    it 'creates vote with value=1' do
      resource.downvote_by(user)
      expect(resource.votes.first.value).to eq(-1)
    end
  end

  describe 'cancel_vote' do
    let!(:vote) { create(:vote, user: user, votable: resource, value: 1) }

    it 'should delete vote of given user' do
      resource.cancel_vote_of(user)
      expect(resource.votes.count).to eq 0
    end
  end

  describe 'rating' do
    let!(:user2) { create(:user) }
    let!(:user3) { create(:user) }
    let!(:vote) { create(:vote, user: user, votable: resource, value: 1) }
    let!(:vote2) { create(:vote, user: user2, votable: resource, value: 1) }
    let!(:vote3) { create(:vote, user: user3, votable: resource, value: -1) }

    it 'should return difference between upvotes and downvotes' do
      expect(resource.rating).to eq 1
    end
  end

  describe 'voted_by?' do
    it 'should be false if user did not vote for resource' do
      expect(resource.voted_by?(user)).to eq false
    end

    it 'should be true if user voted for resource' do
      resource.upvote_by(user)
      expect(resource.voted_by?(user)).to eq true
    end
  end
  
end