Rails.application.routes.draw do
  get 'imported_files/new'
  post 'imported_files/create'
  get '/imported_files', to: 'imported_files#index'
  get 'contacts', to: 'contacts#index'
  get 'contact_logs', to: 'contact_logs#index'
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'contacts#index'
end
