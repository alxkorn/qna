# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  after_create :subscribe_author

  def best_answer
    answers.find_by(best: true)
  end

  def subscribe(user)
    subscribed_users << user unless subscribed?(user)
  end

  def unsubscribe(user)
    subscribed_users.delete(user) if subscribed?(user)
  end

  def subscribed?(user)
    subscribed_users.include? user
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author
    subscribe(user)
  end
end
