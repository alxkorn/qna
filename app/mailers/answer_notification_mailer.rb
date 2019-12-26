class AnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notification_mailer.notify_about_new_answer.subject
  #
  def new_answer_notification(user, answer)
    @greeting = "Hi"

    @answer = answer
    @question = @answer.question

    mail to: user.email
  end
end
