Rails.application.routes.draw do
  resources :bank_accounts, except: :show
  resources :cashboxes, except: :show
  resources :users
  resources :expenses
  root "pages#home"
end
