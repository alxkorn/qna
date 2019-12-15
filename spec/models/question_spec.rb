# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do

  it_should_behave_like 'Votable', :question

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
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
end
