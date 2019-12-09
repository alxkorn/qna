require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:destroy) }
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
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question, best: false) }
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
    end
  end
end
