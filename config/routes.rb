Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/github' => 'omniauth_callbacks#github'
  end

  resources :attachments, only: [:destroy]

  concern :votable do
    resources :votes, only: [:up_rating, :down_rating, :unvote] do
      post :up_rating, on: :collection
      post :down_rating, on: :collection
      post :unvote, on: :collection
    end
  end


  resources :questions, concerns: :votable do
    resources :comments, only: [:create]
    resources :answers, concerns: :votable, shallow: true do
      resources :comments, only: [:create]
      patch :best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
