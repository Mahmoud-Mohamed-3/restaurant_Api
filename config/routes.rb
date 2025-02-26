Rails.application.routes.draw do
  devise_for :owners, controllers: { sessions: "owners/sessions", registrations: "owners/registrations" }
  devise_for :chefs, controllers: { sessions: "chefs/sessions", registrations: "chefs/registrations" }
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
  namespace :v1 do
    post "owner/create_category", to: "owner_permissions#create_category"
    put "owner/update_category", to: "owner_permissions#update_category"
    delete "owner/delete_category/:id", to: "owner_permissions#delete_category"
    post "owner/add_chef", to: "owner_permissions#add_chef"
    delete "owner/delete_chef/:id", to: "owner_permissions#delete_chef"
  end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
