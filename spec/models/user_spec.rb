# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it  { should have_many(:questions).dependent(:destroy) }
    it  { should have_many(:answers).dependent(:destroy) }
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'owns?' do
    context 'user persisted' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:question_not_owned) { create(:question) }
      context 'object responds to user_id' do
        it 'returns true if object belongs to user' do
          expect(user.owns?(question)).to eq true
        end

        it 'returns false if object does not belong to user' do
          expect(user.owns?(question_not_owned)).to eq false
        end
      end

      context 'object does not respond to user_id' do
        it 'returns false' do
          expect(user.owns?(User.new)).to eq false
        end
      end
    end

    context 'user is new' do
      it 'returns false' do
        user = User.new
        object = Question.new

        expect(user.owns?(object)).to eq false
      end
    end
  end
end
