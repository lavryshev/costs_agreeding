Rails.application.routes.draw do
  resources :bank_accounts, except: :show
  resources :cashboxes, except: :show
  resources :users
  get '/registration', to: 'users#registration', as: 'registration'
  post '/register', to: 'users#register', as: 'register'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resource :user_session  
  resources :expenses, except: [:index, :show]
  root "pages#home"
end
