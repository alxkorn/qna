class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = Answer.where(question_id: params[:question_id]) #Question.find(params[:question_id]).answers
    render json: @answers
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end
