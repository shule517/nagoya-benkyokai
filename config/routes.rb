Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :events do
    collection do
      get 'tag'
    end
  end
  resources :tags
  resources :users
  get '/groups/:groupname', to: 'groups#show', groupname: /.*/
  resources :rank do
    collection do
      get 'group'
      get 'place'
      get 'owner'
      get 'user'
      get 'rank'
      get 'amazon'
    end
  end
  root 'events#index'
end
