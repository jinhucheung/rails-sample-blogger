Rails.application.routes.draw do
   
  get 'sessions/new'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  # For static_pages

  get '/help',    to:'static_pages#help'

  get '/about',   to:'static_pages#about'

  get '/contact', to:'static_pages#contact'
 
  # For users

  get '/signup',   to:'users#new'

  post '/signup',  to:'users#create'

  get '/login',    to:'sessions#new'

  post '/login',   to:'sessions#create'

  delete '/logout', to:'sessions#destroy'

  resources :users

  resources :account_activations, only:[:edit]
end
