##
# Get information about a movie from TheMovieDB.
#
class Movie
  @@genres = nil

  ##
  # Parameters injected into each request.
  #
  def self.default_params
    {
      api_key: ENV.fetch('THEMOVIEDB_API_KEY')
    }
  end

  def self.site
    RestClient::Resource.new('https://api.themoviedb.org/3')
  end

  def self.all_genres
    return @@genres if @@genres
    response = site["genre/movie/list"].get params: default_params

    case response.code
    when 200
      return @@genres = JSON.parse(response.body)['genres'].map(&:values).to_h
    end
  end

  ##
  # Find movie from +id+ on different major movie sites (IMDB by default).
  # Specify site with +source+ (:imdb_id, :freebase_mid, :freebase_id, :tvdb_id,
  # :tvrage_id).
  #
  def self.find(id, source = 'imdb_id')
    params = default_params.merge(external_source: source)
    response = site["find/#{id}"].get params: params

    case response.code
    when 200
      data = JSON.parse(response.body)['movie_results'][0]
      new(data) if data
    end
  end

  ##
  # Call +self.find+ and cache the response
  #
  def self.find_cached(id, source = 'imdb_id')
    Rails.cache.fetch("movie:#{source}:#{id}", expires_in: 90.minutes) do
      find id, source
    end
  end

  ##
  # Parse url and call +Movie.find+ if valid id and source is detected
  #
  def self.find_from_url(url)
    if movie_id = url[/\/{2}[^\/]+\.imdb\.com\/[^\/]+\/([^\/\?]+)/, 1]
      source = 'imdb_id'
    else return
    end
    find_cached movie_id, source
  end

  ##
  # Find url on movie sites and call find_from_url with it
  #
  def self.find_from_card(card)
    url = card.attachments.map(&:url).find { |i| i.include?('imdb.com') }
    find_from_url url if url
  end

  def initialize(attributes = {})
    @attributes = attributes.with_indifferent_access
  end

  ##
  # Full URL to backdrop image
  #
  def backdrop_url
    [image_site, backdrop_path].join
  end

  ##
  # Full URL to poster image
  #
  def poster_url
    [image_site, poster_path].join
  end

  ##
  # Array of genres
  #
  def genres
    self.class.all_genres.values_at(*genre_ids)
  end

  def method_missing(meth)
    case meth
    when :name then return title
    when :desc then return overview
    end
    @attributes[meth]
  end

  private

  def image_site
    'https://image.tmdb.org/t/p/w500'
  end

end
