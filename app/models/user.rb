class User
  include Singleton

  ##
  # For handling legacy calls
  #
  def self.bot
    instance
  end

  ##
  # Add backdrop image to the cards of pending movies (except those with
  # existing cover image).
  #
  def self.moviefy_cards
    bot.pending_movies_cached.each { |card| bot.moviefy_card(card) }
  end

  ##
  # Find all cards with +list_id+ matching +TRELLO_PENDING_LIST_ID+
  #
  def pending_movies
    path = "/lists/#{ENV.fetch('TRELLO_PENDING_LIST_ID')}/cards"
    trello.find_many Trello::Card, path
  end

  def pending_movies_cached
    Rails.cache.fetch('trello:pending_movies') { pending_movies }
  end

  ##
  # Find a random movie. If weighted param is `true` (the default) then movies
  # get prioritized by the number of votes they have.
  #
  def random_movie(weighted=true)
    movies = pending_movies_cached
    return movies.sample unless weighted
    key_func = Proc.new{ |card| card }
    weight_func = Proc.new{ |card| card.badges['votes'] }
    Pickup.new(movies, key_func: key_func, weight_func: weight_func).pick
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
    movie = Movie.find_from_url(url)

    unless movie
      logger.warn "Could not find valid IMDB URL on card #{message}"
      return
    end

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
    @member ||= Rails.cache.fetch('trello:me') { trello.find(:member, :me) }
  end

  private

  def trello
    Trello::Client.new(consumer_key: ENV.fetch('TRELLO_CONSUMER_KEY'),
                       consumer_secret: ENV.fetch('TRELLO_CONSUMER_SECRET'),
                       oauth_token: ENV.fetch('TRELLO_OAUTH_TOKEN'),
                       oauth_secret: ENV.fetch('TRELLO_OAUTH_SECRET'))
  end

end
