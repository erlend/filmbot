class CommandsController < ApplicationController

  def create
    return render json: {}, status: 403 unless valid_slack_token?
    CommandJob.perform_later command_params.to_h
    # response type 'ephemeral' if not replying in channel
    render json: { response_type: 'in_channel' }, status: :created
  end

  private

  def command_params
    params.permit(:text, :token, :user_id, :response_url)
  end

  def valid_slack_token?
    params[:token] == ENV.fetch('SLACK_SLASH_COMMAND_TOKEN')
  end

end
