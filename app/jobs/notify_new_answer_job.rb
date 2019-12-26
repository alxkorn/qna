class NotifyNewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::AnswerNotifier.new.notify_subscribers(answer)
  end
end
