Rails.application.routes.draw do
  devise_for :owners, controllers: { sessions: "owners/sessions", registrations: "owners/registrations" }
  devise_for :chefs, controllers: { sessions: "chefs/sessions", registrations: "chefs/registrations" }
  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  namespace :api do
  namespace :v1 do
    post "user/create_order", to: "order#create_order"
    post "user/create_order_item/:order_id", to: "order_item#create_order_item"
    get "user/your_orders", to: "user_actions#get_your_orders"
    get "user/current_user", to: "user_actions#current_user_info"
    get "user/reservations", to: "user_actions#user_reservations"
    get "user/stats", to: "user_actions#user_stats"
    get "show_food/:id", to: "food#show_food"
    get "recommended_food", to: "food#recommended_items"
    post "owner/create_category", to: "owner_permissions#create_category"
    put "owner/update_category/:id", to: "owner_permissions#update_category"
    delete "owner/delete_category/:id", to: "owner_permissions#delete_category"
    post "owner/add_chef", to: "owner_permissions#add_chef"
    delete "owner/delete_chef/:id", to: "owner_permissions#delete_chef"
    put "owner/update_chef/:id", to: "owner_permissions#update_chef"
    get "owner/show_all_chefs", to: "owner_permissions#show_all_chefs"
    post "chef/create_food", to: "chef_actions#create_food"
    put "chef/update_food/:id", to: "chef_actions#update_food"
    delete "chef/delete_food/:id", to: "chef_actions#delete_food"
    post "chef/add_ingredient", to: "chef_actions#add_ingredient"
    put "chef/edit_ingredient/:id", to: "chef_actions#edit_ingredient"
    delete "chef/delete_ingredient/:id", to: "chef_actions#delete_ingredient"
    get "chef/show_all_orders", to: "chef_actions#show_all_orders"
    get "chef/show_pending_orders", to: "chef_actions#show_pending_orders"
    put "chef/update_order_status/:id", to: "chef_actions#update_order_status"
    get "chef/get_your_category", to: "chef_actions#get_your_category"
    get "chefs", to: "chefs#show_chefs_for_users"
    get "chef", to: "chefs#get_current_chef"
    get "user/show_order/:id", to: "user_actions#get_order"
    get "completed_orders", to: "completed_order#get_all_completed_orders"
    get "user/completed_orders", to: "completed_order#get_user_completed_orders"
    put "user/complete_order/:order_id", to: "completed_order#complete_order"
    get "owner/all_orders", to: "order#all_orders"
    get "categories", to: "user_actions#get_categories"
    get "category_food/:id", to: "user_actions#get_category_food"
    post "owner/add_table", to: "tables#create"
    post "user/book_table/:id", to: "reservations#create"
    get "/show_tables", to: "tables#index"
    post "food/search/:query", to: "food#search_food"
    resources :reservations, only: [ :index ]
  end
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
