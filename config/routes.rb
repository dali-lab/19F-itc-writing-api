Rails.application.routes.draw do

  class Auth # used to authenticate requests to /delayed_job
    def matches?(request)
      return false unless request.session.to_hash['enable_admin_pages']
      return request.session.to_hash['enable_admin_pages']
    end
  end

  get '/healthcheck', to: 'application#healthcheck'

  # OmniAuth login mappings
  get '/auth/:provider/callback', to: 'sessions#create', as: :signin
  get '/signout',  to: 'sessions#destroy', as: :signout
  get '/not_authorized', to: "sessions#not_authorized", as: :not_authorized

  get '/email', to: 'application#email' # TODO replaceappname - For test purposes - remove after email test is successful

  get '/main', to: 'things#index'
  get '/new', to: 'things#new'
  get '/show', to: 'things#show'
  get '/edit', to: 'things#edit'
  post '/create', to: 'things#create'
  get '/delete', to: 'things#delete'
  post '/update', to: 'things#update'
  #get '/api/questionnaires', to: 'things#', make controller, make method, make the method spit json, make model call

  unless %{production test}.include?(Rails.env)
    mount LetterOpenerWeb::Engine, at: "/test_emails"
  end

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post], as: 'dj', constraints: Auth.new

  # TODO replaceappname - For test purposes - remove/update before using
  resources :users, only: [:index]

  root 'things#index'
end
