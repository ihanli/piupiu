Piupiu::Application.routes.draw do
  root :to => "high_voltage/pages#show", :id => "index"
 
  devise_for :users, :controllers => { :registrations => "registrations", :passwords => "passwords" } do
    delete "users/:id" => "registrations#destroy"
    get "users" => "users#index", :as => :user_root
    get "users/sign_in" => redirect("/")
  end

  resources :users do
    resources :posts do
      get "comment" => "posts#comment"
      get "download" => "posts#download"
    end
  end
end
