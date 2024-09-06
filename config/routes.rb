Rails.application.routes.draw do
  post "/login", to: "auth#login"
  post "/register", to: "users#create"
  get "/profile", to: "users#profile"
end
