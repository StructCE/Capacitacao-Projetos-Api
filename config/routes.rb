Rails.application.routes.draw do
  devise_for :users, skip: :all
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      scope 'user' do
        post 'create', to: 'user#create'
        put 'update', to: 'user#update'
        delete 'delete', to: 'user#destroy'
        get 'show', to: 'user#show'
      end

      scope 'paintings/' do
        get 'index', to: 'paintings#index'
        post 'create', to: 'paintings#create'
        get 'show/:id', to: 'paintings#show'
        put 'update/:id', to: 'paintings#update'
        delete 'delete/:id', to: 'paintings#delete'
      end

      scope 'style' do
        get 'index', to: 'style#index'
        get 'show/:id', to: 'style#show'
        post 'create', to: 'style#create'
        put 'update/:id', to: 'style#update'
        delete 'delete/:id', to: 'style#delete'
      end

      scope 'painter' do
        get 'index', to: 'painters#index'
        post 'create', to: 'painters#create'
        get 'show/:id', to: 'painters#show'
        put 'update/:id', to: 'painters#update'
        delete 'delete/:id', to: 'painters#delete'
      end

      scope 'gallery' do
        post 'create', to: 'gallery#create'
        get 'index', to: 'gallery#index'
        get 'show/:id', to: 'gallery#show'
        put 'update/:id', to: 'gallery#update'
        delete 'delete', to: 'gallery#delete'
        post 'add_photo', to: 'gallery#add_photo'
        post 'link_painting', to: 'gallery#link_painting'
      end

      get 'login', to: 'sessions#login'
      get 'logout', to: 'sessions#logout'
    end
  end

  get 'authentication_failure', to: 'application#authentication_failure', as: :authentication_failure
end
