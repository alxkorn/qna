module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def upvote_by(user)
    votes.create!(value: 1, user: user)
  end

  def downvote_by(user)
    votes.create!(value: -1, user: user)
  end

  def cancel_vote_of(user)
    votes.find_by(user: user).destroy!
  end

  def rating
    votes.sum(:value)
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end
end