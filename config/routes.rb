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

      get 'login', to: 'sessions#login'
      get 'logout', to: 'sessions#logout'
    end
  end

  get 'authentication_failure', to: 'application#authentication_failure', as: :authentication_failure
end
