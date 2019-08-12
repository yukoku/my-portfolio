Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users, :controllers => {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    invitations: 'users/invitations'
  }
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  resources :users, only: %i[index show destroy], controller: 'users/users'
  resources :projects do
    resources :tickets, except: :index do
      delete 'destroy_attached_file', on: :member
    end
  end
  get '/users/:id/tickets', to: 'tickets#index', as: 'tickets'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
