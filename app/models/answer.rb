# frozen_string_literal: true

class Answer < ApplicationRecord

  include Votable

  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def set_best
    transaction do
      question.best_answer&.update!(best: false)
      reload
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
