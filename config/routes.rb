Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get 'signup' => 'users#new'
  resources :users
end
