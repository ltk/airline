Airline::Application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]
  resource :users, :only => [:new, :create]

  root :to => "users#new"

end
