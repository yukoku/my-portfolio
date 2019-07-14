Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
end
