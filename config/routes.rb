Rails.application.routes.draw do
  resources :bank_accounts, except: :show
  resources :cashboxes, except: :show
  
  resources :users
  get '/registration', to: 'users#registration', as: 'registration'
  post '/register', to: 'users#register', as: 'register'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resource :user_session  
  
  resources :expenses, except: :show do
    get '/page/:page', action: :index, on: :collection
  end
  put '/expenses/:id/agree', to: 'expenses#agree', as: 'expense_agree'
  put '/expenses/:id/disagree', to: 'expenses#disagree', as: 'expense_disagree'

  resources :api_users, except: :show

  get '/permission_error', to: 'pages#permission_error', as: 'permission_error'
  root "pages#home"

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post '/addexpense', to: 'incoming_requests#create_expense'
      end
    end
  end
end
