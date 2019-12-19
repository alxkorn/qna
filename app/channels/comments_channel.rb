class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "question-#{data['id']}"
  end
end