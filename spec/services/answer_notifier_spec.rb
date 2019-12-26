require 'rails_helper'

RSpec.describe Services::AnswerNotifier do
  let!(:users) { create_list(:user, 3) }
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  before do
    users.each do |user|
      question.subscribe(user)
    end
  end

  it 'sends notification about new answer to all subscribed users' do
    users.each { |user| expect(AnswerNotificationMailer).to receive(:new_answer_notification).with(user, answer).and_call_original }
    author = question.user
    expect(AnswerNotificationMailer).to receive(:new_answer_notification).with(author, answer).and_call_original
    subject.notify_subscribers(answer)
  end
end