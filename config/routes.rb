Wikenso::Application.routes.draw do
  resources :wikis, only: [:new, :create]
  get "/new" => "wikis#new"
  scope constraints: {:subdomain => /.+/} do
    resources :demo_wiki_sessions, only: [:create]
    resources :users, only: [:index]
    resources :pending_users, only: [:create]
    post 'user_invitation_emails/:user_id' => "user_invitation_emails#create", as: 'resend_invitation_email'

    get '/redeem/:invitation_code' => "pending_users#edit", as: 'redeem_invitation_code'
    put '/redeem/:invitation_code' => "pending_users#update"

    get "/settings" => "wikis#edit", as: :edit_wiki_settings
    put "/settings" => "wikis#update", as: :wiki_settings

    resources :sessions, only: [:new, :create]
    delete "/logout" => "sessions#destroy", as: :logout

    resources :pages, except: [:index] do
      resources :page_versions, only: [:index, :show], as: :changes, path: :changes
    end

    resources :draft_pages, only: [:destroy]
    get "/" => "pages#show"
  end
  root :to => 'static_pages#landing_page'

  namespace :admin do
    resources :statistics, only: :index
    resources :welcome_pages, only: [:new, :create]
  end

  namespace :api do
    namespace :v1 do
      resources :draft_pages, only: :update
    end
  end
end
