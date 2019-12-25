# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it_should_behave_like 'Votable', :question
  it_should_behave_like 'Commentable', :question

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribed_users).through(:subscriptions) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should accept_nested_attributes_for :reward }
  end

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'best_answer' do
    let!(:question) { create(:question) }

    context 'question has best answer' do
      let!(:answer) { create(:answer, question: question, best: true) }

      it 'should return best answer' do
        expect(question.best_answer).to eq answer
      end
    end

    context "question doesn't have best answer" do
      let!(:answer) { create(:answer, question: question, best: false) }

      it 'should return nil' do
        expect(question.best_answer).to eq nil
      end
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  context 'subscriptions' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }

    describe 'creating question automatically subscribes author to it' do
      it 'creates subscription' do
        expect { create(:question, user: user) }.to change(user.subscriptions, :count).by(1)
      end
    end

    describe 'subscribe' do
      context 'user is not subscribed' do
        it 'creates subscription record' do
          expect { question.subscribe(user) }.to change(question.subscribed_users, :count).by(1)
        end
      end

      context 'user is subscribed already' do
        let!(:subscription) { create(:subscription, user: user, question: question) }
        it 'does not create subscription record' do
          expect { question.subscribe(user) }.to_not change(question.subscribed_users, :count)
        end
      end
    end

    describe 'unsubscribe' do
      context 'user is subscribed' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'deletes subscription record' do
          expect { question.unsubscribe(user) }.to change(question.subscribed_users, :count).by(-1)
        end
      end

      context 'user is not subscribed' do
        it 'does not delete subscription record' do
          expect { question.unsubscribe(user) }.to_not change(question.subscribed_users, :count)
        end
      end
    end

    describe 'subscribed?' do
      context 'user is not subscribed' do
        it 'returns false' do
          expect(question.subscribed?(user)).to eq false
        end
      end

      context 'user is subscribed' do
        let!(:subscription) { create(:subscription, user: user, question: question) }

        it 'returns true' do
          expect(question.subscribed?(user)).to eq true
        end
      end
    end
  end
end
