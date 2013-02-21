Airline::Application.routes.draw do

  resource :users, :only => [:new, :create]

  root :to => "users#new"

end
