class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin, :updated_at, :created_at
end
