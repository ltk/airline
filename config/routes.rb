Airline::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  resources :users, :except => :show
  resource :invitation, :only => [:new, :create]

  root :to => "users#new"
end
