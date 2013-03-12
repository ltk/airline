Airline::Application.routes.draw do
  match "/user/password/edit/:token" => "passwords#edit", :as => :pretty_edit_user_password

  resource :session, :only => [:new, :create, :destroy]

  resource :user, :except => :show do
    resource :password, :only => [:edit, :update]
  end
  
  resource :invitation, :only => [:new, :create]
  resource :password, :only => [:new, :create]
  resources :images, :only => [:create]
  resource :company, :only => [:show]

  match "/:company_slug" => "company_image_streams#index", :as => :company_images
  match "/:company_slug/:user_slug" => "user_image_streams#index", :as => :company_user_images

  root :to => "homepage#show"
end
