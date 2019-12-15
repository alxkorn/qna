# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to :votable }
    it { should belong_to :user }
  end

  describe 'validations' do
    let(:vote) { create(:vote, :for_question) }

    describe 'numericality' do
      subject { vote }
      it { should validate_numericality_of(:value).only_integer.is_less_than_or_equal_to(1).is_greater_than_or_equal_to(-1) }
    end
    
    describe 'uniqueness' do
      subject { vote }
      it { should validate_uniqueness_of(:user_id).scoped_to(:votable_id, :votable_type) }
    end

    describe 'authorship' do
      let(:user) { create(:user) }

      describe 'if user is author of votable' do
        let!(:question) { create(:question, user: user) }
        let!(:vote) { build(:vote, user: user, votable: question) }

        it 'should be invalid' do
          expect(vote).to_not be_valid
        end
      end

      describe 'if user is not author of votable' do
        let!(:question) { create(:question) }
        let!(:vote) { build(:vote, user: user, votable: question) }

        it 'should be valid' do
          expect(vote).to be_valid
        end
      end
    end
  end
end
