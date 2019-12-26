# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Answer, type: :model do

  it_should_behave_like 'Votable', :answer
  it_should_behave_like 'Commentable', :answer

  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'validations' do
    it { should validate_presence_of :body }

    context 'answer is best' do
      let(:answer) { create(:answer, best: true) }
      subject { answer }
      it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
    end

    context 'answer is not best' do
      let(:answer) { create(:answer, best: false) }
      subject { answer }
      it { should_not validate_uniqueness_of(:best).scoped_to(:question_id) }
    end
  end

  describe 'set_best' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:reward1) { create(:reward, :with_image, question: question) }
    let!(:answer1) { create(:answer, question: question, best: false, user: user) }
    let!(:answer2) { create(:answer, question: question, best: true) }

    context 'answer is best already' do
      it 'should keep the value of best attribute' do
        expect do
          answer2.set_best
          answer2.reload
        end.to_not change(answer2, :best)
      end
    end

    context 'answer is not best currently' do
      it "should change answer's best attribute to true" do
        answer1.set_best
        answer1.reload

        expect(answer1.best).to eq true
      end

      it "should change other answers' best attribute to false" do
        answer1.set_best
        answer2.reload

        expect(answer2.best).to eq false
      end

      it "should assign answer's user to question's reward" do
        expect do
          answer1.set_best
          reward1.reload
        end.to change(reward1, :user_id).from(nil).to(user.id)
      end
    end
  end

  describe 'subscriptions' do
    let(:answer) { build(:answer) }

    it 'causes subscribes to recieve notification after question created' do
      expect(NotifyNewAnswerJob).to receive(:perform_later).with(answer)
      answer.save!
    end
  end
end
