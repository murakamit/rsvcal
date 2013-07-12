Rsvcal::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'top#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resource :session, only: [:new, :create, :destroy]
  get "session" => "sessions#index"

  resources :groups, only: [:index, :show]

  resources :items, only: [:index, :show]

  resources :items do
    member do
      get "prop"
      get "today"
    end
  end

  get "/items/:id/:year-:month" => "items#year_month", constraints: { year: /\d{4}/, month: /\d{1,2}/ }, as: :ym_item

  get "/items/:id/:year-:month-:day" => "items#year_month_day", constraints: { year: /\d{4}/, month: /\d{1,2}/, day: /\d{1,2}/ }, as: :ymd_item

  # resources :weeklies

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
  namespace :admin do
    root "top#index"
    resources :groups, only: [:new, :create, :edit, :update, :destroy]
    resources :items,  only: [:new, :create, :edit, :update, :destroy]
  end
end
