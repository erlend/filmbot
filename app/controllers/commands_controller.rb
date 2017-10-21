class CommandsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    return render json: {}, status: 403 unless valid_slack_token?
    CommandJob.perform_later command_params.to_h
    render json: { response_type: response_type }, status: :created
  end

  private

  def command_params
    params.permit(:text, :token, :user_id, :response_url)
  end

  def valid_slack_token?
    params[:token] == ENV.fetch('SLACK_SLASH_COMMAND_TOKEN')
  end

  def response_type
    params[:text].to_s.strip.split(' ').include?('private') &&
      'ephemeral' || 'in_channel'
  end

end
