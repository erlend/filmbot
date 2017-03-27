class WebhooksController < ActionController::Metal

  def show
    response.status = 200
  end

  def create
    require_valid_signature!

    case params[:action][:type].to_sym
    when :addAttachmentToCard
      data = params[:action][:data]
      bot.moviefy_card(data[:card][:id], data[:attachment][:url])
    else
      Rails.logger.debug "Unimplemented action type '#{params[:action][:type]}'"
    end

    response.status = 200
  end

  private

  def bot
    @bot ||= User.bot
  end

  def action?(action)
    params[:action][:type] == action
  end

  ##
  # Verify the "X-Trello-Webhook" signature
  #
  def require_valid_signature!
    signature = request.headers['X-Trello-Webhook']

    if base64_digest(request.body.read + request.url) != signature
      raise "Invalid signature in header 'X-Trello-Webhook'"
    end
    request.body.rewind
  end

  def base64_digest(content)
    sha1 = OpenSSL::Digest.new('sha1')
    digest = OpenSSL::HMAC.digest(sha1, ENV['TRELLO_CONSUMER_SECRET'], content)

    Base64.encode64(digest).chomp
  end

end
