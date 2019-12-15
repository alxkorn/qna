# frozen_string_literal: true

class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, uniqueness: { scope: %i[votable_id votable_type] }
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: -1, less_than_or_equal_to: 1 }
  validate :authorship

  private

  def authorship
    errors.add(:user, "can't vote as author") if user&.owns?(votable)
  end
end
