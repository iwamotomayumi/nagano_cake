Rails.application.routes.draw do

# 顧客用
# URL /customers/sign_in ...
devise_for :customers,skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

scope module: :public do
    root to: "homes#top"
    get "/about" => "homes#about", as:"about"
    get "/customers/my_page" => "customers#show"
    get "/customers/information/edit" => "customers#edit"
    patch "/customers/my_page/update" => "customers#update"
    get 'customers/unsubscribe'
    patch 'customers/withdrawal'
    delete 'cart_items/destroy_all'
    post 'orders/confirm'
    get 'orders/thanks'
    resources :items, only: [:index, :show]
    resources :customers, only: [:show, :edit, :update]
    resources :cart_items, only: [:index, :update, :destroy, :create, :destroy_all]
    resources :orders, only: [:new, :create, :index, :show]
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]
  end

 namespace :admin do
    root to: "homes#top"
    resources :order_details, only: [:update]
    resources :items
    resources :genres, only: [:index, :create, :edit, :update, :new]
    resources :customers, only: [:index, :show, :edit, :update]
    resources :orders, only: [:show, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
