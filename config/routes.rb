Piupiu::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  root :to => "high_voltage/pages#show", :id => "index"

  devise_for :users, :controllers => { :registrations => "registrations", :passwords => "passwords", :sessions => "sessions" } do
    delete "users/:id" => "registrations#destroy"
    get "users/sign_up" => "registrations#new"
    get "users" => "users#index", :as => :user_root
    get "users/sign_in" => redirect("/")
  end

  resources :users do
      post "attachement_upload" => "users#attachement_upload"
  end

  resources :posts do
    get "comment" => "posts#comment"
    get "download" => "posts#download"
    post "report" => "posts#report"
  end
end
