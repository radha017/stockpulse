Rails.application.routes.draw do
  devise_for :users, controller: {
    registration: 'users/registrations'
  }
  resources :transactions, only: [:index, :show, :display, :buy]
  resources :admin do
    member do
      patch :update_role
      get :edit_role
      end
  end
  root 'portfolios#home'
  get '/dashboard' => "admin#dashboard", as: "dashboard"
  get '/market' => "portfolios#market", as: "market"
  get '/portfolio' => "portfolios#portfolio", as: "portfolio"
  get '/history' => "portfolios#history", as: "history"
  get '/:symbol' => "transactions#index", as: "home"
  get '/display/:symbol' => "transactions#display", as: "display"
  get '/displays/:symbol' => "transactions#displays", as: "displays"
  post '/buy/:symbol', to: 'transactions#buy', as: 'buy'
  post '/sell/:symbol', to: 'transactions#sell', as: 'sell'
  patch 'admin/:id/approve', to: 'admin#approve', as: "approve"
  
 
end
