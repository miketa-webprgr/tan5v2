Rails.application.routes.draw do
  root "top#index"

  get "login" => "sessions#new", as: :login
  post "session" => "sessions#create", as: :session
  delete "session" => "sessions#destroy"

  post 'change_favorite', to: 'favorites#change'
  post 'change_tango_config', to: 'tango_configs#change'

  resources :users, shallow: true do
    get :search , on: :collection
    get :suspend, on: :member
    resources :wordnotes, only: [:show], shallow: false do
      post 'download_csv' , to: 'wordnotes#download_csv'
      post 'upload_csv' , to: 'wordnotes#upload_csv'
    end
    resources :wordnotes, except: [:index, :new, :edit, :show] do
      resources :tangos, only: [:create, :update, :destroy] do
        post 'change_tango_data', to: 'tango_data#change', as: 'change_data_of', on: :member
        get 'get_tango_data', to: 'tango_data#get_tango_data', as: 'get_data_of', on: :member
      end
      delete 'delete_checked_tangos', to: 'tangos#delete_checked_tangos', as: 'delete_checked_tangos_on', on: :member
      post 'create_on_list', to: 'tangos#create_on_list', as: 'create_tangos_on_list_of', on: :member
    end
  end
  
end
