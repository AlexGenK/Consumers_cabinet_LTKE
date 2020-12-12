Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :consumers do
    resources :en_payments
    resources :messages
    resources :previous_en_consumptions
    resource  :en_bid
    resource  :current_en_consumptions
  end

  root to: 'consumers#index'
end
