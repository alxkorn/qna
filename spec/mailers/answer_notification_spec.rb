require "rails_helper"

RSpec.describe AnswerNotificationMailer, type: :mailer do
  describe "notify_about_new_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { AnswerNotificationMailer.new_answer_notification(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer notification")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    # it "renders the body" do
    #   expect(mail.body.encoded).to match("Hi")
    # end
  end

end
