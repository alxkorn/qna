require 'rails_helper'

RSpec.describe NotifyNewAnswerJob, type: :job do
  let(:service) { double('Services::AnswerNotifier') }
  let(:answer) { create(:answer) }

  before do
    allow(Services::AnswerNotifier).to receive(:new).and_return(service)
  end

  it 'calls Services::AnswerNotifier#notify(answer)' do
    expect(service).to receive(:notify_subscribers).with(answer)
    NotifyNewAnswerJob.perform_now(answer)
  end
end
