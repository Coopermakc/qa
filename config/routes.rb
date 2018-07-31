Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    post '/github' => 'omniauth_callbacks#github'
    post '/vkontakte' => 'omniauth_callbacks#vkontakte'
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
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
