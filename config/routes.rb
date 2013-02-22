Airline::Application.routes.draw do
  match '/users/new/:code' => 'users#new', :as => 'redeem_invitation'

  resource :session, :only => [:new, :create, :destroy]
  resource :users, :only => [:new, :create]
  resource :invitation, :only => [:new, :create]

  root :to => "users#new"
end
