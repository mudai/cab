Fly::Application.routes.draw do
  scope module: :user do
    root to: "home#index"

    get 'login', to: 'sessions#new', as: 'login'
    post 'login_process', to: 'sessions#create', as: 'login_process'
    get 'logout', to: 'sessions#destroy', as: 'logout'
    get 'signup', to: 'registrations#new', as: 'signup'
    post 'signup_process', to: 'registrations#create', as: 'signup_process'
    get 'signup_provisional', to: 'registrations#signup_provisional', as: 'signup_provisional'
    get 'signup_token/:token', to: 'registrations#signup_token', as: 'signup_token'
    get 'signup_error', to: 'registrations#signup_error', as: 'signup_error'
    get 'signup_confirmed', to: 'registrations#signup_confirmed', as: 'signup_confirmed'

    resource :account, only: [:edit, :update]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get '*a', to: 'errors#routing'

  #scope '/admin/:org_dir', module: :admin do # 管理画面
  #  root to: 'home#index', as: :admin_root
  #  get 'login', to: 'sessions#new', as: 'admin_login'
  #  get 'logout', to: 'sessions#destroy', as: 'admin_logout'
  #end

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
