Rails.application.routes.draw do
  
  devise_for :users

  get 'payments/update_budget_items' => 'payments#update_budget_items'
  get 'payments/hgnotify' => 'payments#hg_notify'
  get 'campaigns/:id/budget' => 'campaigns#budget', as: 'campaign_budget'
  get 'campaigns/:id/payments' => 'campaigns#payments', as: 'campaign_payments'
  get 'campaigns/:id/support' => 'campaigns#support', as: 'campaign_support'

  resources :budget_items
  resources :payments
  resources :campaigns

  get 'post_images/upload'
  post 'post_images/upload' => 'post_images#upload'
  get 'post_images' => 'post_images#index'

  root 'campaigns#index'
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
