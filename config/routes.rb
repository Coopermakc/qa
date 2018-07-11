Rails.application.routes.draw do
  devise_for :users

  resources :attachments, only: [:destroy]

  concern :votable do
    resources :votes, only: [:up_rating, :down_rating, :unvote] do
      post :up_rating, on: :collection
      post :down_rating, on: :collection
      post :unvote, on: :collection
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable, shallow: true do
      patch :best, on: :member
    end
  end
  root to: "questions#index"

  mount ActionCable.server => '/cable'
end
