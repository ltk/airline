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

  scope :constraints => lambda{|req| req.session[:user_id].present? } do
    match "/:company_slug" => "images#index", :as => :company_images
    match "/:company_slug/:user_slug" => "images#index", :as => :company_user_images
    root :to => redirect { |p,req| company_feed_path(req) }
  end

  match "/:company_slug(/:user_slug)" => redirect("/")
  root :to => "homepage#show"

  def company_feed_path(request)
    "/#{request_user(request).company_slug}"
  end

  def request_user(request)
    User.find(request.session[:user_id])
  end
end
