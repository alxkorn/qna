# frozen_string_literal: true

class Api::V1::QuestionsController < Api::V1::BaseController
  skip_before_action :verify_authenticity_token, only: %i[create update destroy]
  before_action :set_question, only: %i[show update destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      render json: @question
    else
      head :bad_request
    end
  end

  def update
    return head :forbidden unless current_user&.owns?(@question)

    if @question.update(question_params)
      render json: @question
    else
      head :bad_request
    end
  end

  def destroy
    return head :forbidden unless current_user&.owns?(@question)

    @question.destroy
    head :ok
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, reward_attributes: %i[name image],
                                                    links_attributes: %i[id _destroy name url])
  end

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end
end
