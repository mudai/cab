Fly::Application.routes.draw do
  get '/', to: 'errors#routing' # rootへのaccessは404とする
  scope '/admin/:org_dir', module: :admin do # 管理画面
    root to: 'home#index', as: :admin_root
    get 'login', to: 'sessions#new', as: 'admin_login'
    get 'logout', to: 'sessions#destroy', as: 'admin_logout'
  end
  scope ":org_dir", module: :user do # ユーザー画面
    root to: "home#index"
    get 'login', to: 'sessions#login', as: 'login'
    post 'login_process', to: 'sessions#login_process', as: 'login_process'
    get 'logout', to: 'sessions#logout', as: 'logout'
    get 'signup', to: 'registrations#signup', as: 'signup'
    get 'signup_process', to: 'registrations#process', as: 'signup_process'
    
    resource :account, only: [:edit, :update]
  end
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
