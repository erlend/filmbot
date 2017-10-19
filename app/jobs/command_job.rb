class CommandJob < ApplicationJob
  queue_as :default

  def perform(params)
    card = User.bot.random_movie(params[:text].strip != "all")
    url = card.attachments.map(&:url).find { |i| i.include?('imdb.com/') }
    movie = Movie.find_from_url(url) || card
    # voters = card.voters.map { |voter| voter.full_name.split(' ').first }
    author = card.actions.last.member_creator

    message = {
      response_type: 'in_channel',
      attachments: [{
        fallback: movie.name,
        # color: '#36a64f',
        # pretext: "As voted on by #{voters.to_sentence}",
        # author_name: ,
        # author_link: author.url,
        # author_icon: author.avatar_url,
        title: movie.name,
        title_link: card.url,
        text: movie.desc,
        image_url: movie.try(:poster_url),
        fields: [
          {
            title: 'Votes',
            value: card.voters.count,
            short: true
          }, {
            title: 'IMDb',
            value: movie.vote_average,
            short: true
          }, {
            title: 'Added by',
            value: author.full_name.split(' ').first,
            short: true
          }, {
            title: 'Genres',
            value: movie.genres.to_sentence,
            short: true
          }
        ]
      }]
    }

    RestClient.post params[:response_url], message.to_json, content_type: :json
  end
end
