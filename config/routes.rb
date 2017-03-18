Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'auth',                    to: 'sessions#new',     as: :new_session
  get 'auth/:provider/callback', to: 'sessions#create'
  delete 'auth',                 to: 'sessions#destroy', as: :session

  constraints(-> (req) { req.session[:user_id]}) do
    resource :raffle, path: '', only: :show do
      get 'equal'
    end
  end

  root to: redirect('/auth')
end
