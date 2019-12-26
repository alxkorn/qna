# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper
  root to: 'questions#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  
  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :cancel_vote
    end
  end
  
  resources :questions, except: %i[edit], concerns: :votable do
    # post :subscribe, on: :member
    # delete :unsubscribe, on: :member
    resources :subscriptions, shallow: true, only: %i[create destroy]
    resources :comments, only: %i[create]
    resources :answers, shallow: true, only: %i[destroy create update], concerns: :votable do
      resources :comments, only: %i[create]
      patch :set_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :exceptme, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  mount ActionCable.server => '/cable'
end
