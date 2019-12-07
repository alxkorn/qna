# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users
  
  resources :questions, except: %i[edit] do
    resources :answers, shallow: true, only: %i[destroy create update] do
      patch :set_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
end
