class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user_id
  has_many :files
  has_many :comments
  has_many :links
  # belongs_to :user
end
