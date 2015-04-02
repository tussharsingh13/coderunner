Rails.application.routes.draw do
<<<<<<< HEAD
  devise_for :users
=======

#Resources for Contests and Problems
resources :contests do
	resources :problems
	end
>>>>>>> 579597d1d7623e11bcac3626b71d779cc5c84e3a
  get 'welcome/index' #This ensures that index action is invoked by action controller when localhost../welcome/index URL is entered

#For Submitting code using Editor
   post 'actions/submitcode' 
   get 'actions/submitcode'
   get 'actions/editor'

#For Submitting code using files
  get 'actions/uploadfile'
  post 'actions/savefile'
  
#For uploadin files to aws  
  post 'actions/uploadedtoaws'
  get 'actions/uploadtoaws'
  
 #For contest page
  post 'contests/contestadded'
  
#For contest page
  post 'contests/new'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  #root 'actions#editor'

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
