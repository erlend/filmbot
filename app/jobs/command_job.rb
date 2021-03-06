class CommandJob < ApplicationJob
  queue_as :default

  def perform(params)
    text = params[:text].to_s.strip.split(' ')
    card = User.bot.random_movie(!text.include?('simple'))
    url = card.attachments.map(&:url).find { |i| i.include?('imdb.com/') }
    movie = Movie.find_from_url(url) || card
    author = card.actions.last.member_creator

    message = {
      response_type: text.include?('private') && 'ephemeral' || 'in_channel',
      attachments: [{
        fallback: movie.name,
        # color: '#36a64f',
        title: movie.name,
        title_link: card.url,
        text: movie.desc,
        image_url: movie.try(:poster_url),
        fields: [
          {
            title: 'Rating',
            value: movie.vote_average,
            short: true
          }, {
            title: 'Release date',
            value: movie.release_date,
            short: true
          }, {
            title: 'Votes',
            value: card.voters.count,
            short: true
          }, {
            title: 'Added by',
            value: author.full_name.split(' ').first,
            short: true
          }, {
            title: 'Genres',
            value: movie.genres.to_sentence,
            short: false
          }
        ]
      }]
    }

    RestClient.post params[:response_url], message.to_json, content_type: :json
  end
end
