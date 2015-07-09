Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  get 'home/sanpham', to: 'home#sanpham', as: :sanpham
  
  post '/mua_san_pham', to: 'giaodiches#create', as: :mua_san_pham
  post '/change_sanpham_hangsanxuat/:hsx', to: 'home#change_sanpham_hangsanxuat', as: :change_sanpham_hangsanxuat
  post '/change_sanpham_giaban/:giaban', to: 'home#change_sanpham_giaban', as: :change_sanpham_giaban 
  post '/change_sanpham_hedieuhanh/:hedieuhanh', to: 'home#change_sanpham_hedieuhanh', as: :change_sanpham_hedieuhanh 
  post '/change_sanpham_ten', to: 'home#change_sanpham_ten', as: :change_sanpham_ten 
  
  post '/search_relation_item', to: 'home#search', as: :search_relation_item 

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
