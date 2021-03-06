Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'late_plates#index'

  get 'test' => "application#test"

  resources :late_plates, only: [:create, :destroy]
  post 'add' => "late_plates#twilio_endpoint"
  get 'help' => "late_plates#help"

  get 'quick_add' => "late_plates#create"

  resources :coopers, only: [:index, :edit, :update, :new, :create] do
    resources :sms_confirmations, only: [:new, :create]

    resources :repeat_plates
    resources :phrases, only: [:index, :create, :destroy]
  end

  get 'feedback' => "feedback#new"
  post 'feedback' => "feedback#create"

  get 'auth/google_oauth2/callback', to: "sessions#create"
  resource :sessions, only: [:create, :destroy]
  delete "signout" => "sessions#destroy"

  get 'textsim' => "text_sim#new"

  get "error" => "application#error"

  namespace :api do
    resources :coopers
  end

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
