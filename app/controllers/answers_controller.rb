# frozen_string_literal: true

class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update set_best]
  after_action :publish_answer, only: [:create]

  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    return head :forbidden unless current_user&.owns?(@answer)

    @answer.destroy
    flash[:notice] = 'Your answer was deleted'
  end

  def update
    return head :forbidden unless current_user&.owns?(@answer)

    @answer.files.attach(answer_params[:files]) if answer_params[:files]
    @answer.update(answer_params.except(:files))
    @answer.reload
  end

  def set_best
    @question = @answer.question
    return head :forbidden unless current_user&.owns?(@question)

    @answer.set_best
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id _destroy name url])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question-#{@answer.question.id}",
      {event: 'answer created', answer_id: @answer.id, question_id: @answer.question.id }
    )
  end
end
