Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :objectives, only: [:index, :show] do
    member do
      patch :confirm
    end

    resources :steps, only: [:show, :create]
  end

  resources :steps, only: [:update, :destroy] do
    member do
      patch :mark_step_as_done
    end
  end

  resources :chats, only: [:create] do
    resources :messages, only: [:create]
  end
end
