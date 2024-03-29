# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  devise_for :users
  # configure root
  # https://github.com/CircuitVerse/CircuitVerse/blob/master/config/routes.rb#L66
  #
  root 'home#index'
  # change root to innate/index
  get '/buynow', to: 'home#buynow'
  get '/settings', to: 'home#settings'

  resources :about, only: :index
  get "/404", to: "errors#not_found"
  get "/422", to: "errors#unacceptable"
  get "/500", to: "errors#internal_error"

  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"

  # for routes 
  # https://github.com/CircuitVerse/CircuitVerse/blob/master/config/routes.rb
  #
  # API
  namespace :api do
    # get '/users_by_email' => "users_by_emails#show", as: :users_by_email
    resources :favourites, only: [:create, :destroy]
  end

  # RESOURCES
  resources :freecourses, only: :show
  resources :paidcourses, only: :show

  # To add stripe missing payments here
  resources :reservations, only: :new, controller: 'paidcourses/reservation'

  # Continue from here
  resources :accounts, only: [:show, :update]
  resources :passwords, only: [:show ,:update]
 # resources :profiles, only: [:show ,:update]

  put '/teachermaker/:user_id' => 'teachermaker#update', as: :teachermaker
  put '/adminmaker/:user_id' => 'adminmaker#update', as: :adminmaker
  put '/studentmaker/:user_id' => 'studentmaker#update', as: :studentmaker

  scope "/users" do
    get "/:id/profile", to: redirect('/users/%{id}'), as: "profile"
   # get "/:id/profile", to: "users/innate#show", as: "profile"
    get "/:id/profile/update", to: "users/innate#edit", as: "profile_update"
 #   patch "/:id/update", to: "users/innate#update", as: "profile_update"
    get "/:id/groups", to: "users/innate#groups", as: "user_groups"
    get "/:id/", to: "users/innate#index", as: "user_projects"
    get "/educational_institute/typeahead/:query" => "users/circuitverse#typeahead_educational_institute"
    get "/:id/notifications", to: "users/noticed_notifications#index", as: "notifications"
    patch "/:id/notifications/mark_all_as_read", to: "users/noticed_notifications#mark_all_as_read", as: "mark_all_as_read"
    patch "/:id/notifications/read_all_notifications", to: "users/noticed_notifications#read_all_notifications", as: "read_all_notifications"
    post "/:id/notifications/mark_as_read/:notification_id", to: "users/noticed_notifications#mark_as_read", as: "mark_as_read"
  end

  namespace :teacher do
    get '/dashboard' => 'dashboard#index', as: :dashboard
    resources :freecourses, except: :index
  end

  namespace :dashboard do
    get '/dashboard' => 'dashboard#index', as: :dashboard
    resources :freecourses, except: :index
  end

  namespace :admin do
    get '/dashboard' => 'dashboard#index', as: :dashboard
    resources :paidcourses, only: :new
  end

  namespace :student do
    get '/dashboard' => 'dashboard#index', as: :dashboard
  end
end
# rubocop:enable Metrics/BlockLength
