Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :plants, only: [:new, :create] do
    member do
      resources :turns
    end
  end

  get "/", to: redirect("/plants/new")

end
