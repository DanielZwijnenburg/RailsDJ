Djrails::Application.routes.draw do
  root :to => "application#index"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "sign_up" => "users#new", :as => "sign_up"
  get "search" => "application#search", :as => :search

  resources :songs, :artists, :albums, :users, :votes, :histories, :setups, :sessions
  get "/add/:id" => "queues#add", :as => "add"
  get "/playwaawawawawaw" => "application#play", :as => "play"
  get "/pausewaawawawawaw" => "application#pause", :as => "pause"
  get "/stopwaawawawawaw" => "application#stop", :as => "stop"
  get "/volumewaawawawawaw/:id" => "application#volume", :as => "volume"
  get "/artists" => "artists#index", :as => "artists"
  get "/albums" => "albums#index", :as => "albums"
  get "/songs" => "songs#index", :as => "songs"
  get "/setups/completed/:id" => "setups#completed", :as => "setup_completed"
end
