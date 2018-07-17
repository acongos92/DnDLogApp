Rails.application.routes.draw do


  resources :items
  resources :magic_items
  resources :characters
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  #
  # character inventory management routes
  #
  delete 'character_magic_items/:id' => 'characters#remove_owned_magic_item', as: :remove_owned_magic_item
  delete 'character_item/:id' => 'characters#remove_owned_item', as: :remove_owned_item
  # You can have the root of your site routed with "root"
  root 'characters#index', as: :home
  get 'single_log/:id/display' => 'single_log#display', as: :new_quest
  post 'single_log/:id/:quest/generate' => 'single_log#generate', as: :generate_log
  get 'single_log/:id/:quest/tp_info' => 'single_log#show_magic_item_tp_addition', as: :show_magic_item_tp_addition
  post 'single_log/:id/validate' => 'single_log#validate_and_save_quest', as: :validate_and_save_quest
  get 'single_log/:id/:quest/new_magic_item' => 'single_log#add_magic_item_during_level_up', as: :add_magic_item_during_level_up
  post 'single_log/:id/:quest/post_magic_item' => 'single_log#post_magic_item_during_level_up', as: :purchase_magic_item_during_quest

  #
  # Standard Item Purchase Routes
  #
  get 'purchase/:id' => 'purchase_item#new', as: :purchase_item_form
  post 'purchase/:id' => 'purchase_item#buy', as: :purchase_item_transaction

  #
  # Standalone Magic Item Selection Route
  #
  get 'magic_item_select/:id' => 'character_magic_item#show', as: :purchase_magic_item_form
  post 'magic_item_purchase/:id' => 'character_magic_item#buy', as: :purchase_magic_item_transaction
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
