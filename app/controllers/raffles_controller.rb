class RafflesController < ApplicationController

  def show
    @card = random_card(current_user.pending_movies).pick
    redirect_to config_path unless @card
  end

  def equal
    @card = current_user.pending_movies.sample
    render :show
  end

  private

  def random_card(cards)
    key_func = Proc.new{ |card| card }
    weight_func = Proc.new{ |card| card.badges['votes'] }
    Pickup.new(cards, key_func: key_func, weight_func: weight_func)
  end

end
