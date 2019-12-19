# frozen_string_literal: true

class AnswersChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['id']}"
  end

  def get_answer_html(data)
    user = if data['user_id'] == 'guest'
             nil
           else
             User.find(data['user_id'])
           end
    answer = Answer.find(data['answer_id'])

    # answer_html = ApplicationController.render(
    #   partial: 'answers/answer',
    #   locals: { answer: answer, user: user }
    # )

    answer_html = ApplicationController.render_with_signed_in_user(
      user,
      partial: 'answers/answer',
      locals: { answer: answer }
    )

    data_back = { event: 'created answer html', answer_html: answer_html }
    transmit data_back
  end
end
