Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :consumers do
  	resources :en_payments
  end

  root to: 'consumers#index'
end
