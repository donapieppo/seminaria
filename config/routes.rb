Rails.application.routes.draw do
  get 'seminars/archive/(:year)',   controller: 'seminars',   action: 'archive', as: 'archive_seminars'
  get 'highlights/archive/(:year)', controller: 'highlights', action: 'archive', as: 'archive_highlights'

  get 'totem', controller: 'home', action: 'totem', as: 'totem'

  get 'user/seminars',   controller: 'seminars',   action: 'index', only_current_user: true,  as: 'user_seminars'
  get 'funds/seminars',  controller: 'seminars',   action: 'index', funds_current_user: true, as: 'funds_seminars'
  get 'user/cycles',     controller: 'cycles',     action: 'index',                           as: 'user_cycles'
  get 'user/highlights', controller: 'highlights', action: 'index', only_current_user: true,  as: 'user_highlights'

  resources :seminars do
    get  :choose_type, on: :collection
    get  :mail_text,   on: :member
    post :submit_mail_text, on: :member
    resources :documents
    resources :repayments
  end

  resources :serials do
    resources :seminars
  end

  resources :cycles do
    resources :seminars
  end
  
  resources :highlights do
    get :admin, on: :collection
    put :publish, on: :member
    put :refuse, on: :member
    resources :approvals
  end

  resources :approvals
  resources :repayments do
    post :notify, on: :member
    get  :choose_fund, on: :member
    post :update_fund, on: :member
    get  :print_letter, on: :member
    get  :print_decree, on: :member
    get  :print_proposal, on: :member
  end

  resources :documents do
    get :download, on: :member
  end

  resources :funds do
    get :owners, on: :collection
    get :justifications, on: :member
  end

  root to: 'seminars#index'
end
