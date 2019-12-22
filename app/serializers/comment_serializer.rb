class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :updated_at, :created_at, :user_id
  belongs_to :user
end
