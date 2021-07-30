Rails.application.routes.draw do
  mount DmUniboCommon::Engine => "/dm_unibo_common"

  get '/choose_organization', to: "home#choose_organization"
  # https://tester.dm.unibo.it/seminars/zoom-oauth
  get '/zoom-oauth',    to: "zoom#oauth"
  get '/zoom/show',     to: "zoom#new"
  get '/zoom/user',     to: "zoom#user"
  get '/zoom/list',     to: "zoom#list"

  get '/logins/logout', to: 'dm_unibo_common/logins#logout'

  scope ":__org__" do
    get 'seminars/archive/(:year)',   controller: 'seminars',   action: 'archive', as: 'archive_seminars'

    get 'totem', controller: 'home', action: 'totem', as: 'totem'

    get 'user/seminars',  controller: 'seminars', action: 'index', only_current_user: true,  as: 'user_seminars'
    get 'funds/seminars', controller: 'seminars', action: 'index', funds_current_user: true, as: 'funds_seminars'
    get 'user/cycles',    controller: 'cycles',   action: 'index',                           as: 'user_cycles'

    resources :places
    resources :arguments

    resources :seminars do
      get  :choose_type, on: :collection
      get  :mail_text,   on: :member
      post :submit_mail_text, on: :member
      resources :documents
      resources :repayments
      resources :registrations

      # seminar_zoom_create  -> /:__org__/seminars/:seminar_id/zoom/create(.:format)
      get '/zoom/create', to: "zoom#create", as: :zoom_create
    end

    resources :serials do
      resources :seminars
    end

    resources :cycles do
      resources :seminars
    end

    resources :conferences do
      resources :seminars
    end

    resources :repayments do
      post :notify, on: :member
      get  :choose_fund, on: :member
      post :update_fund, on: :member

      get  :print_request,   on: :member
      get  :print_letter,    on: :member
      get  :print_decree,    on: :member
      get  :print_proposal,  on: :member
      get  :print_repayment, on: :member
      get  :print_refund,    on: :member
      get  :print_other,     on: :member

      resources :curricula_vitae
    end

    resources :funds 

    namespace(:speaker) do
      resources :repayments do
        get  :accept,              on: :member
        get  :data_request,        on: :member
        post :submit_data_request, on: :member
        resources :id_cards
      end
    end

    resources :registrations

    get '/', to: 'seminars#index', as: 'current_organization_root'
  end

  get 'serials', to: redirect('mat/serials', status: 302)
  get 'serials/(:id)', to: redirect('mat/serials/%{id}', status: 302)
  get 'cycles', to: redirect('mat/cycles', status: 302)
  get 'cycles/(:id)', to: redirect('mat/cycles/%{id}', status: 302)
  #get 'seminars/archive', to: redirect('mat/seminars/archive', status: 302)
  #get 'seminars/archive/(:year)', to: redirect('mat/seminars/archive/%{year}', status: 302)
  #get 'seminars', to: redirect('mat/seminars', status: 302)
  #get 'seminars/(:id)', to: redirect('mat/seminars/%{id}', status: 302)

  root to: 'seminars#index'
end
