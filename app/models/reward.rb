class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :image

  validates :name, :image, presence: true
end
