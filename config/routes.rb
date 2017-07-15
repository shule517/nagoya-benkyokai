Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Web
  root 'events#index'
  resources :events, :only => [:index] do
    collection do
      get 'tag'
    end
  end
  get '/groups/:groupname', to: 'groups#show', groupname: /.*/
  get '/users/:userid', to: 'users#show', userid: /.*/

  # WebAPI
  namespace :api, { format: 'json' } do
    namespace :v1, :only => [:index] do
      resources :events
    end
  end

  # おためし機能
  resources :rank, :only => [] do
    collection do
      get 'group'
      get 'place'
      get 'owner'
      get 'user'
      get 'rank'
      get 'amazon'
    end
  end
end
