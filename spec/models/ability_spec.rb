# frozen_string_literal: true

require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, :admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'questions' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, create(:question, user: user) }
      it { should_not be_able_to :update, create(:question, user: other) }

      it { should be_able_to :destroy, create(:question, user: user) }
      it { should_not be_able_to :destroy, create(:question, user: other) }

      context 'votes' do
        let(:question_owned) { create(:question, user: user) }

        it { should be_able_to :upvote, create(:question) }
        it { should be_able_to :downvote, create(:question) }
        it { should_not be_able_to :cancel_vote, create(:question) }

        it { should_not be_able_to :upvote, question_owned }
        it { should_not be_able_to :downvote, question_owned }
        it { should_not be_able_to :cancel_vote, question_owned }

        context 'voted already' do
          let(:question) { create(:question) }
          let!(:vote) { create(:vote, votable: question, user: user) }

          it { should_not be_able_to :upvote, question }
          it { should_not be_able_to :downvote, question }

          it { should be_able_to :cancel_vote, question }
        end
      end
    end

    context 'answers' do
      let(:answer) { create(:answer, user: user) }
      let(:answer_not_owned) { create(:answer, user: other) }

      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, answer_not_owned }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, answer_not_owned }

      describe 'set_best' do
        let(:question_owned) { create(:question, user: user) }
        let(:answer_for_question_owned) { create(:answer, question: question_owned)}

        it { should_not be_able_to :set_best, create(:answer) }

        it { should be_able_to :set_best, answer_for_question_owned }
      end

      context 'votes' do
        let(:answer_owned) { create(:answer, user: user) }
        let(:answer_not_owned) { create(:answer) }

        it { should be_able_to :upvote, answer_not_owned }
        it { should be_able_to :downvote, answer_not_owned }
        it { should_not be_able_to :cancel_vote, answer_not_owned }

        it { should_not be_able_to :upvote, answer_owned }
        it { should_not be_able_to :downvote, answer_owned }
        it { should_not be_able_to :cancel_vote, answer_owned }

        context 'voted already' do
          let(:answer) { create(:answer) }
          let!(:vote) { create(:vote, votable: answer, user: user) }

          it { should_not be_able_to :upvote, answer }
          it { should_not be_able_to :downvote, answer }

          it { should be_able_to :cancel_vote, answer }
        end
      end
    end

    describe 'comments' do
      it { should be_able_to :create, Comment }
    end

    describe 'files' do
      let(:answer) { create(:answer, :with_attached_file, user: user) }
      let(:answer_not_owned) { create(:answer, :with_attached_file, user: other) }
      let(:file_owned) { answer.files.first }
      let(:file_not_owned) { answer_not_owned.files.first }

      it { should be_able_to :destroy, file_owned }
      it { should_not be_able_to :destroy, file_not_owned }
    end

    describe 'links' do
      let(:link_owned) { create(:link, linkable: create(:answer, user: user)) }
      let(:link_not_owned) { create(:link, linkable: create(:answer, user: other)) }
      
      it { should be_able_to :destroy, link_owned }
      it { should_not be_able_to :destroy, link_not_owned }
    end


  end
end
