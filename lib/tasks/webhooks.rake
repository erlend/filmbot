namespace :webhooks do
  desc "Create webhook for Trello"
  task create: :environment do
    client = User.instance
    list = client.send(:trello).find(:list, ENV.fetch('TRELLO_PENDING_LIST_ID'))
    client.create_webhook(callback_url: webhook_url, id_model: list.board_id)
  end
end
