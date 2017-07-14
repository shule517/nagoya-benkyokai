Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'events#index'
  resources :events do
    collection do
      get 'tag'
    end
  end
  get '/groups/:groupname', to: 'groups#show', groupname: /.*/
  get '/users/:userid', to: 'users#show', userid: /.*/
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
end
