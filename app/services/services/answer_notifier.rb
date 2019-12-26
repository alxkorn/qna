# frozen_string_literal: true

class Services::AnswerNotifier
  def notify_subscribers(answer)
    question = answer.question
    question.subscribed_users.find_each(batch_size: 500) do |user|
      AnswerNotificationMailer.new_answer_notification(user, answer).deliver_later
    end
  end
end
