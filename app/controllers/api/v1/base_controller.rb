# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  skip_authorization_check

  before_action :doorkeeper_authorize!

  private

  def current_resource_owner
    if doorkeeper_token
      @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
