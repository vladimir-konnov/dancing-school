Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\

  root to: 'root#index'

  #resource :account

  resources :styles
  resources :subscription_types
  resources :students do
    get :autocomplete, on: :collection
    get :filter, on: :collection
    resources :subscriptions
  end
  resources :lessons do
    #get :students, on: :collection
    post :add_student, on: :member
    delete 'remove_student/:student_id', action: :remove_student, on: :member, as: :remove_student
  end

  get '/payrolls', controller: :payrolls, action: :index, as: :payrolls
end
