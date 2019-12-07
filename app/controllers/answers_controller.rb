# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update set_best]

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

    @answer.update(answer_params)
  end

  def set_best
    @question = @answer.question
    return head :forbidden unless current_user&.owns?(@question)
    # byebug
    @answer.set_best
    # byebug
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def set_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end
end
