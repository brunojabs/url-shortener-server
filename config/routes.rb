Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  resources :urls, param: :slug, only: %w(create show index) do
    member do
      patch :hit
    end
  end
end
