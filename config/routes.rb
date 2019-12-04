# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[destroy create update] do
      patch :set_best, on: :member
    end
  end

  root to: 'questions#index'
end
