Rails.application.routes.draw do
  get 'seminars/archive/(:year)', to: 'seminars#archive', as: 'archive_seminars'
  get 'totem',                    to: 'home#totem', as: 'totem'

  get 'user/seminars',   controller: 'home',   action: 'index', only_current_user: true, as: 'user_seminars'
  get 'user/cycles',     controller: 'cycles', action: 'index',                          as: 'user_cycles'

  resources :organizations do
    resources :admins
  end
  resources :admins

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
  
  resources :repayments do
    post :notify, on: :member
    get  :choose_fund, on: :member
    post :fund, on: :member
  end

  resources :documents do
    get :download, on: :member
  end

  resources :rooms

  root to: 'home#index'
end
