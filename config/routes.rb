VsetAuction2::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :auctions
  resources :auction_items
  resources :bids, only: [:new, :create]
  resources :comments, only: [:destroy]

  root 'static_pages#home'

  match '/signup',    to: 'users#new',		  via: 'get'
  match '/signin',    to: 'sessions#new',	  via: 'get'
  match '/signout',   to: 'sessions#destroy',	  via: 'delete'
  match '/password_reset',   to: 'sessions#password_reset',	  via: 'get'
  match '/forgot_password',   to: 'sessions#forgot_password',	  via: 'post'
  match '/password_change',   to: 'sessions#password_change',	  via: 'get'
  match '/update_password',   to: 'sessions#update_password',	  via: 'post'
  match '/help',      to: 'static_pages#help',	  via: 'get'
  match '/about',     to: 'static_pages#about',	  via: 'get'
  match '/contact',   to: 'static_pages#contact', via: 'get'
  match '/no-auction',   to: 'static_pages#no_auction', via: 'get'
  match '/category',  to: 'auction_items#category', via: 'get'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
