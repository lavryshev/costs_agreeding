Rails.application.routes.draw do
  resources :bank_accounts, except: :show
  resources :cashboxes, except: :show
  resources :users
  resources :expenses, except: [:index, :show]
  root "pages#home"
end
