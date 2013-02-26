Airline::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  resource :users, :except => :show
  resource :invitation, :only => [:new, :create]

  root :to => "users#new"
end
