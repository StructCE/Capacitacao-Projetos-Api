Rails.application.routes.draw do
  devise_for :users
  namespace 'api' do 
    namespace 'v1' do 
      scope 'paintings/' do 
        get 'index', to: "paintings#index"
        post 'create', to: "paintings#create"
        get 'show/:id', to: "paintings#show"
        patch 'update/:id', to: "paintings#update"
        delete 'delete/:id', to: "paintings#delete"
      end
    end
  end
end
