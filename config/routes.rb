Rails.application.routes.draw do
  devise_for :users, controllers: {
    #masquerades: 'admin/masquerades',
    registrations: 'users/registrations'
  }

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html\

  root to: 'root#index'

  get '/help' => 'root#help', as: :help

  resource :administration

  resources :styles
  resources :subscription_types
  resources :students do
    get :autocomplete, on: :collection
    get :filter, on: :collection
    resources :subscriptions
  end
  resources :lessons do
    post :add_student, on: :member
    delete 'remove_student/:student_id', action: :remove_student, on: :member, as: :remove_student
  end

  get '/payrolls', controller: :payrolls, action: :index, as: :payrolls
end
