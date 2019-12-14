# frozen_string_literal: true

module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :set_resource, only: %i[upvote downvote cancel_vote]
  end

  def upvote
    return head :forbidden if @resource.voted_by?(current_user) || current_user.owns?(@resource)

    @resource.upvote_by(current_user)
    render_json
  end

  def downvote
    return head :forbidden if @resource.voted_by?(current_user) || current_user.owns?(@resource)

    @resource.downvote_by(current_user)
    render_json
  end

  def cancel_vote
    return head :forbidden unless @resource.voted_by?(current_user)

    @resource.cancel_vote_of(current_user)
    render_json
  end

  private

  def set_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json
    render json: { rating: @resource.rating, selector: "##{@resource.class.to_s.downcase}-#{@resource.id}" }, data: {voting: true}
  end
end
