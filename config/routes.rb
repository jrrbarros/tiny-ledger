Rails.application.routes.draw do
  get "accounts/:id/balance", to: "accounts#balance"
  post "accounts/:id/deposit", to: "accounts#deposit"
  post "accounts/:id/withdraw", to: "accounts#withdraw"
  get "accounts/:id/transactions", to: "accounts#transactions"
end
