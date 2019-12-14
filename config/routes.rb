# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
      delete :cancel_vote
    end
  end
  
  resources :questions, except: %i[edit], concerns: :votable do
    resources :answers, shallow: true, only: %i[destroy create update], concerns: :votable do
      patch :set_best, on: :member
    end
  end

  resources :files, only: %i[destroy]
  resources :links, only: %i[destroy]
  resources :rewards, only: %i[index]
end
