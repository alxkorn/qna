# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  # has_many :votes, dependent: :destroy, as: :votable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def best_answer
    answers.find_by(best: true)
  end
end
