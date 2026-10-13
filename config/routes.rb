Rails.application.routes.draw do
  devise_for :users,
             path: "api/v1",
             path_names: { sign_in: "login", sign_out: "logout", registration: "signup" },
             controllers: { sessions: "users/sessions", registrations: "users/registrations" }

  namespace :api do
    namespace :v1 do
      resource  :profile, only: %i[show update]
      resources :items,   only: %i[index show]
      resources :orders,  only: %i[index show create]

      namespace :admin do
        resources :items
        resources :users, only: %i[index show update destroy]
      end
    end
  end
end