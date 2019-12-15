class ApplicationController < ActionController::Base
  after_action :gon_user, unless: :devise_controller?

  private

  def gon_user
    cookies[:user_id] = current_user&.id || 'guest'
  end
end
