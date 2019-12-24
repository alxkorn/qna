# frozen_string_literal: true

class Api::V1::AnswersController < Api::V1::BaseController
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy update]
  authorize_resource

  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      render json: @answer
    else
      head :bad_request
    end
  end

  def destroy
    return head :forbidden unless current_user&.owns?(@answer)

    @answer.destroy
    head :ok
  end

  def update
    return head :forbidden unless current_user&.owns?(@answer)

    if @answer.update(answer_params)
      render json: @answer
    else
      head :bad_request
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id _destroy name url])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
