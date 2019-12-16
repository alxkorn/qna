# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: %i[create]
  after_action :publish_comment, only: %i[create]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.commentable = @commentable
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    question_id = if @commentable.is_a? Question
                    @commentable.id
                  elsif @commentable.is_a? Answer
                    @commentable.question.id
                  end

    stream = "question-#{question_id}"
    ActionCable.server.broadcast(
      stream,
      email: @comment.user.email, comment_body: @comment.body, commentable_type: @commentable.type, commentable_id: @commentable.id
    )
  end

  def set_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        @commentable = Regexp.last_match(1).classify.constantize.find(value)
      end
    end
    nil
  end
end
