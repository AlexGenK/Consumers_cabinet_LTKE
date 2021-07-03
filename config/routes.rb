Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users

  resources :consumers do
  	resources :messages

    resources :en_payments
    resources :previous_en_consumptions
    resources :en_adjustments
    resources :monthlies do
      resources  :dailies, only: [:index] 
      post 'selector', on: :collection
    end
    resource  :en_bid
    resource  :en_invoice, only: [:show]

    resources :gas_payments
    resources :previous_gas_consumptions
    resources :gas_adjustments
    resource  :gas_bid
    resource  :gas_invoice, only: [:show]
  end

  resources :d_companies
  
  namespace :admin do
    resource :receiver, controller: 'receiver', only: [:edit, :update]

    get 'filling_consumers',  to: 'filling_consumers#set_params'
    post 'filling_consumers', to: 'filling_consumers#start'

    get 'filling_current_en_consumptions',  to: 'filling_current_en_consumptions#set_params'
    post 'filling_current_en_consumptions', to: 'filling_current_en_consumptions#start'

    get 'filling_current_gas_consumptions',  to: 'filling_current_gas_consumptions#set_params'
    post 'filling_current_gas_consumptions', to: 'filling_current_gas_consumptions#start'

    get 'filling_previous_en_consumptions',  to: 'filling_previous_en_consumptions#set_params'
    post 'filling_previous_en_consumptions', to: 'filling_previous_en_consumptions#start'
    delete 'filling_previous_en_consumptions', to: 'filling_previous_en_consumptions#destroy'

    get 'filling_previous_gas_consumptions',  to: 'filling_previous_gas_consumptions#set_params'
    post 'filling_previous_gas_consumptions', to: 'filling_previous_gas_consumptions#start'
    delete 'filling_previous_gas_consumptions', to: 'filling_previous_gas_consumptions#destroy'

    get 'filling_en_certificates',  to: 'filling_en_certificates#start'

    get 'filling_gas_certificates', to: 'filling_gas_certificates#start'

    get 'report_clients', to: 'report_clients#show'
  end

  root to: 'consumers#index'
end
