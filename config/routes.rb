Rails.application.routes.draw do
  root "top#index"
  resources :users do
    get :search , on: :collection
    member do
      get :suspend
      post 'change_tango_config', to: 'tango_configs#change'
    end
    resources :wordnotes do
      post 'download_csv' , to: 'wordnotes#download_csv'
      post 'upload_csv' , to: 'wordnotes#upload_csv'
      resources :tangos do
        post 'change_tango_data', to: 'tango_data#change'
        get 'get_tango_data', to: 'tango_data#get_tango_data'
      end
      delete 'delete_checked_tangos', to: 'tangos#delete_checked_tangos'
      post 'create_on_list', to: 'tangos#create_on_list'
    end
  end
  
  get "login" => "sessions#new", as: :login
  post "session" => "sessions#create", as: :session
  delete "session" => "sessions#destroy"
end
