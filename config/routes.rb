Airline::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]

  resource :users, :except => :show do
    resource :password, :only => [:edit, :update]
  end
  
  resource :invitation, :only => [:new, :create]
  resource :password, :only => [:new, :create]

  root :to => "users#new"
end
