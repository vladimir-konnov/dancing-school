Rails.application.routes.draw do
  devise_for :users, controllers: {
    #masquerades: 'admin/masquerades',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    delete '/users/:id' => 'users/registrations#delete_user', as: :delete_user_registration
  end

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\

  root to: 'root#index'

  get '/help' => 'root#help', as: :help

  resource :administration

  resources :styles do
    get :visits, on: :member
  end
  resources :subscription_types
  resources :students do
    get :autocomplete, on: :collection
    get :filter, on: :collection
    resources :subscriptions
    get :visits, on: :member
  end
  resources :lessons do
    post :add_student, on: :member
    delete 'remove_student/:student_id', action: :remove_student, on: :member, as: :remove_student
  end

  get '/payrolls', controller: :payrolls, action: :index, as: :payrolls
end
