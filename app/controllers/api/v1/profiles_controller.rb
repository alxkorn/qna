# frozen_string_literal: true

class Api::V1::ProfilesController < Api::V1::BaseController
  # authorize_resource class: false

  def me
    render json: current_resource_owner
  end

  def exceptme
    render json: User.where.not(id: current_resource_owner.id) if current_resource_owner
  end
end
