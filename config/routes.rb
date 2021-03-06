Lfti::Application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  resources :abouts, :only => [:show]
  resources :user_pages, :only => [:show], path: 'u'
  resources :things, :only => [:index, :show, :new, :create] do
    resources :comments, :only => [:create] do
      resources :helpfulnesses, :only => [:create]
    end
    resources :votes, :only => [:create]
    resources :havables, :only => [:create]
    resources :buys, only: [:index]
  end
  resources :images, :only => [:create, :destroy]
  resources :events, :only => [:show]
  resources :redirect, :only => [:index]

  get 's', to: 'shops#index', as: 'shops'
  get 's/:k', to: 'shops#show', as: 'shop'
  get '/shops', to: redirect('/s')
  get '/shops/:k', to: redirect('/s/%{k}')
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
