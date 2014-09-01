Rails.application.routes.draw do
  devise_for :users
  resources :reviews do
    member do
      post 'upvote'
      post 'delete_vote'
    end
  end
  

  root :to => "reviews#index"
  
  get '/movies/:id' => 'movies#profile', as: :movie
  get '/users/:id' => 'users#profile', as: :user
  get '/movies/confirm/:id' => 'movies#confirm', as: :confirm_movie
  get '/movies/confirm/:id/update_information' => 'movies#confirm_dbid', as: :confirm_dbid_movie
  get '/reviews/:id/flag' => 'reviews#flag', as: :flag_review
  get '/movies/:id/flag' => 'movies#flag', as: :flag_movie
  
  get '/flagged' => 'statics#flagged', as: :flagged
  get '/about' => 'statics#about', as: :about
  
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