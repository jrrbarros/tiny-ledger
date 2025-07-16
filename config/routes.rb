Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "accounts/:id/deposit", to: "accounts#deposit"
  post "accounts/:id/withdraw", to: "accounts#withdraw"
  get "accounts/:id/transactions", to: "accounts#transactions"
end
