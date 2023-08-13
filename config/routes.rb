Rails.application.routes.draw do
  resources :sources, except: :show
  
  resources :users
  get '/registration', to: 'users#registration', as: 'registration'
  post '/register', to: 'users#register', as: 'register'
  resources :password_resets, only: %i[new create edit update]
  resource :user_session  
  
  resources :expenses, only: %i[index show] do
    collection do
      get '/page/:page', action: :index
      get 'list'
    end
  end
  put '/expenses/:id/agree', to: 'expenses#agree', as: 'expense_agree'
  put '/expenses/:id/disagree', to: 'expenses#disagree', as: 'expense_disagree'

  resources :external_apps, except: :show

  get '/permission_error', to: 'pages#permission_error', as: 'permission_error'
  root "pages#home"

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        post 'expenses', to: 'expenses#create'
        patch 'expense', to: 'expenses#update'
        put 'expense', to: 'expenses#update'
        delete 'expense', to: 'expenses#destroy'

        post 'organizations', to: 'organizations#create'
        patch 'organization', to: 'organizations#update'
        put 'organization', to: 'organizations#update'
        delete 'organization', to: 'organizations#destroy'

        post 'divisions', to: 'divisions#create'
        patch 'division', to: 'divisions#update'
        put 'division', to: 'divisions#update'
        delete 'division', to: 'divisions#destroy'
      end
    end
  end
end
