# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[destroy create]
  end

  root to: 'questions#index'
end
