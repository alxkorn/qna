# frozen_string_literal: true

class ApplicationController < ActionController::Base
  after_action :gon_user, unless: :devise_controller?
  check_authorization unless: :devise_controller?

  def self.render_with_signed_in_user(user, *args)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i| i.set_user(user, scope: :user) }
    renderer = self.renderer.new('warden' => proxy)
    renderer.render(*args)
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private

  def gon_user
    cookies[:user_id] = current_user&.id || 'guest'
  end
end
