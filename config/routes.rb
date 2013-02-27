Airline::Application.routes.draw do
  match "/user/password/edit/:token" => "passwords#edit", :as => :pretty_edit_user_password

  resource :session, :only => [:new, :create, :destroy]

  resource :user, :except => :show do
    resource :password, :only => [:edit, :update]
  end
  
  resource :invitation, :only => [:new, :create]
  resource :password, :only => [:new, :create]
  resources :images, :only => [:new, :create]

  root :to => "users#new"
end
