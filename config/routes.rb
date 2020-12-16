Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :consumers do
  	resources :messages

    resources :en_payments
    resources :previous_en_consumptions
    resource  :en_bid
    resource  :en_invoice, only: [:show]

    resources :gas_payments
    resources :previous_gas_consumptions
    resource  :gas_bid
    resource  :gas_invoice, only: [:show]
  end

  namespace :admin do
    resource :receiver, controller: 'receiver', only: [:edit, :update]
  end

  root to: 'consumers#index'
end
