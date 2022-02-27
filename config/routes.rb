Rails.application.routes.draw do
  get 'chats/show'
  get 'relationships/followings'
  get 'relationships/followers'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root :to => "homes#top"
  get "home/about" => "homes#about"
  get "search" => "searches#search_result"

  # ゲストログイン
  devise_scope :user do
    post 'users/guest_sign_in' => 'users/sessions#guest_sign_in'
  end

  # チャット機能
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]


  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  resources :users do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :users, only: [:index, :show, :edit, :update] do
    get "search", to: "users#search"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
