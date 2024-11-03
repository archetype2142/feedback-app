# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :admin do
    resource :dashboard, only: [:index] do
      get 'export', to: 'dashboard#export'
    end
    resources :feedbacks
    root to: 'dashboard#index'
    resources :sentiment_analysis, only: [:index, :show] do
      get :feedback_list, on: :collection
      get :emotion_details, on: :member
    end
    
    resources :topic_clusters, only: [:index, :show] do
      get :show_topic, on: :collection
      get :topic_feedbacks, on: :collection
    end
    
    resources :summaries, only: [:index] do
      get :generate_summary, on: :collection
    end
    
    resources :impact_analysis, only: [:index] do
      get :feature_impact, on: :collection
    end
  end

  namespace :api do
    post 'feedback/initial', to: 'feedbacks#initial'
    resources :feedbacks, only: [:index, :show, :create] do
      resources :replies, only: [:create]
    end
  end

  root to: 'home#index'
  get 'feedback', to: 'home#index'
end
