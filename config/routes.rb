Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get  'webhook', to: WebhooksController.action(:show)
  post 'webhook', to: WebhooksController.action(:create)
  post 'command', to: 'commands#create'
  get  'movies', to: 'movies#index'

  root to: redirect('https://snakkes.slack.com')
end
