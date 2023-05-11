Rails.application.routes.draw do
  resources :bank_accounts
  resources :cashboxes
  resources :users
  resources :expenses
  root "pages#home"
end
