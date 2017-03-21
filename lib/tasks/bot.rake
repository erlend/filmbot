namespace :bot do

  desc 'List boards accessible by the bot'
  task list_boards: :environment do
    User.bot.member.boards.each do |board|
      puts "#{board.id} - #{board.name} #{"(closed)" if board.closed}"
      board.lists.each do |list|
        puts "  #{list.id} - #{list.name} #{"(closed)" if list.closed}"
      end
    end
  end

  desc 'Add backdrop image to the cards of pending movies'
  task moviefy: :environment do
    user = User.bot
    user.pending_movies.reject(&:cover_image_id).each do |card|
      user.add_backdrop_to_card(card)
    end
  end

end
