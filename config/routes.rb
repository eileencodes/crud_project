BigRubyConf2014::Application.routes.draw do
  resources :users do
    resources :contacts
  end

  post 'login' => 'sessions#create', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout
  root 'welcome#index'
end
