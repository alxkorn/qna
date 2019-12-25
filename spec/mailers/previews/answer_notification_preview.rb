# Preview all emails at http://localhost:3000/rails/mailers/answer_notification
class AnswerNotificationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_notification/notify_about_new_answer
  def notify_about_new_answer
    AnswerNotificationMailer.notify_about_new_answer
  end

end
