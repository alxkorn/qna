class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"
    now = Time.zone.now
    @questions = Question.where(created_at: (now - 24.hours)..now)

    mail to: user.email
  end
end
