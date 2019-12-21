class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy]

  authorize_resource

  def destroy
    return head :forbidden unless current_user&.owns?(@linkable)

    @link.destroy
  end

  private

  def set_link
    @link = Link.find(params[:id])
    @linkable = @link.linkable
  end
end
