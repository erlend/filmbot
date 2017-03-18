class User < ActiveRecord::Base
  has_many :activities, foreign_key: 'owner_id'
  cron_job :moviefy_cards, interval: 1.hour

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
    find_by(bot: true, provider: 'trello')
  end

  ##
  # Add backdrop image to the cards of pending movies (except those with
  # existing cover image).
  #
  def self.moviefy_cards
    bot.pending_movies.reject(&:cover_image_id).each do |card|
      message = "\"#{card.id}\" - #{card.name}"
      begin
        url = card.attachments.map(&:url).find { |i| i.include?('imdb.com/') }
        imdb_id = url[/\/{2}[^\/]+\.imdb\.com\/[^\/]+\/([^\/\?]+)/, 1]

        movie = Movie.find(imdb_id)

        card.add_attachment movie.backdrop_url
        logger.info "Added cover image to card #{message}"
      rescue NoMethodError
        logger.warn "Could not find valid IMDB URL on card #{message}"
      end
    end
  end

  ##
  # Find all cards with +list_id+ matching +TRELLO_PENDING_LIST_ID+
  #
  def pending_movies
    path = "/lists/#{ENV.fetch('TRELLO_PENDING_LIST_ID')}/cards"
    trello.find_many Trello::Card, path
  end

  private

  def trello
    Trello::Client.new(consumer_key: ENV.fetch('TRELLO_CONSUMER_KEY'),
                       consumer_secret: ENV.fetch('TRELLO_CONSUMER_SECRET'),
                       oauth_token: oauth_token,
                       oauth_secret: oauth_secret)
  end

end
