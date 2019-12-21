# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[upvote downvote cancel_vote]
    before_action :set_resource, only: %i[upvote downvote cancel_vote]
  end

  def upvote
    authorize! :upvote, @resource

    @resource.upvote_by(current_user)
    render_json
  end

  def downvote
    authorize! :downvote, @resource

    @resource.downvote_by(current_user)
    render_json
  end

  def cancel_vote
    authorize! :cancel_vote, @resource

    @resource.cancel_vote_of(current_user)
    render_json
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json
    render json: { rating: @resource.rating, id: @resource.id, type: @resource.class.to_s.downcase }
  end
end
