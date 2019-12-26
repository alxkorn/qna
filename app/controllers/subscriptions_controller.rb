class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_subscription, only: %i[destroy]
  authorize_resource

  def create
    return head :forbidden if @question.subscribed?(current_user)

    @subscription = Subscription.create(question: @question, user: current_user)
    # @question.subscribe(current_user)

    flash['notice'] = 'You have been successfully subscribed'
  end

  def destroy
    @question = @subscription.question
    @subscription.destroy

    flash['notice'] = 'You have been successfully unsubscribed'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
