class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi"
    now = Time.zone.now
    @questions = Question.where(created_at: (now - 24.hours)..now)

    mail to: user.email
  end
end
