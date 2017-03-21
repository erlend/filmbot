class ConfigsController < ApplicationController

  def show
    @bot = User.bot
  end

  def update
    @webhook = current_user.create_webhook(callback_url: webhook_url,
                                           id_model: trello_list.board_id)
    redirect_to config_path
  end

  private

  def trello_list
    current_user.send(:trello).find(:list, ENV.fetch('TRELLO_PENDING_LIST_ID'))
  end

end
