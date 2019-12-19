module Commentable
  extend ActiveSupport::Concern

  def type
    self.class.to_s.downcase
  end
end