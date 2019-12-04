# frozen_string_literal: true

class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def set_best
    transaction do
      question.best_answer&.update!(best: false)
      reload
      update!(best: true)
    end
  end
end
