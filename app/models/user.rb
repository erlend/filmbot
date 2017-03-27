class User < ActiveRecord::Base

  ##
  # Find or create user from +OmniAuth+ auth hash, then update the user's name
  # and credentials.
  #
  def self.from_omniauth(auth)
    return unless auth.is_a?(Hash)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid).tap do |user|
      user.name = auth.info.name
      if auth.credentials?
        user.oauth_token  = auth.credentials.token
        user.oauth_secret = auth.credentials.secret
      end
      user.save
    end
  end

  ##
  # Find first user marked as bot. This user must be present in order for
  # background jobs to run.
  #
  def self.bot
    @@bot ||= where.not(webhook_id: nil).first
  end

  ##
  # Add backdrop image to the cards of pending movies (except those with
  # existing cover image).
  #
  def self.moviefy_cards
    bot.pending_movies.each { |card| bot.moviefy_card(card) }
  end

  ##
  # Find all cards with +list_id+ matching +TRELLO_PENDING_LIST_ID+
  #
  def pending_movies
    path = "/lists/#{ENV.fetch('TRELLO_PENDING_LIST_ID')}/cards"
    trello.find_many Trello::Card, path
  end

  ##
  # Find card by +card_id+
  #
  def find_card(card_id)
    trello.find(:card, card_id)
  end

  ##
  # Add movie name, description, and, backdrop to card if the card has a valid
  # IMDB url attached or provided with the +url+ parameter.
  #
  def moviefy_card(card, url = nil)
    card = trello.find(:card, card) if card.is_a?(String)
    message = "\"#{card.id}\" - #{card.name}"

    url ||= card.attachments.map(&:url).find { |i| i.include?('imdb.com/') }
    imdb_id = url[/\/{2}[^\/]+\.imdb\.com\/[^\/]+\/([^\/\?]+)/, 1] if url

    unless imdb_id
      logger.warn "Could not find valid IMDB URL on card #{message}"
      return
    end

    movie = Movie.find(imdb_id)
    card.add_attachment(movie.backdrop_url) unless card.cover_image_id
    card.name = movie.title
    card.desc = movie.overview
    if card.save
      logger.info "Added movie info to card #{message}"
    else
      logger.warn "Could not save movie info to card #{message}"
    end
  end

  ##
  # Find webhook from the user's +webhook_id+ or return nil if it is missing
  #
  def webhook
    return unless webhook_id
    @webhook ||= Trello::Webhook.find webhook_id
  end

  ##
  # Create webhook and set the user's +webhook_id+.
  #
  def create_webhook(options)
    trello.create(:webhook, options).tap do |webhook|
      update!(webhook_id: webhook.id)
    end
  end

  ##
  # Finds +Trello::Member+ for this user
  #
  def member
    @member ||= trello.find(:member, :me)
  end

  private

  def trello
    Trello::Client.new(consumer_key: ENV.fetch('TRELLO_CONSUMER_KEY'),
                       consumer_secret: ENV.fetch('TRELLO_CONSUMER_SECRET'),
                       oauth_token: oauth_token,
                       oauth_secret: oauth_secret)
  end

end
