# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
  validate :authorship

  private

  def authorship
    errors.add(:user, "can't vote as author") if user&.owns?(votable)
  end
end
