Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'auth',                    to: 'sessions#new',     as: :new_session
  get 'auth/:provider/callback', to: 'sessions#create'
  delete 'auth',                 to: 'sessions#destroy', as: :session

  get  'webhook', to: WebhooksController.action(:show)
  post 'webhook', to: WebhooksController.action(:create)
  post 'command', to: 'commands#create'

  constraints(-> (req) { req.session[:user_id] }) do
    resource :config, only: [:show, :update]

    resource :raffle, path: '', only: :show do
      get 'equal'
    end
  end

  root to: redirect('/auth')
end
