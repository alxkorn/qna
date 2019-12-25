# frozen_string_literal: true

class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[show index]
  before_action :set_question, only: %i[show edit update destroy subscribe]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
  end

  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_reward
  end

  def subscribe
    @question.subscribe(current_user)

    flash['notice'] = 'You have been successfully subscribed'
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    return head :forbidden unless current_user&.owns?(@question)

    @question.files.attach(question_params[:files]) if question_params[:files]
    @question.update(question_params.except(:files))
    @question.reload
  end

  def destroy
    if current_user.owns?(@question)
      @question.destroy
      flash[:notice] = 'Your question was deleted'
    end
    redirect_to questions_path
  end

  private

  def set_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question',
        locals: { question: @question }
      )
    )
  end

  def question_params
    params.require(:question).permit(:title, :body, reward_attributes: %i[name image],
                                                    files: [], links_attributes: %i[id _destroy name url])
  end
end
