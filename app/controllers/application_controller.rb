class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

  private

  ##
  # Redirect to the login page if +current_user+ is missing.
  #
  def require_user!
    redirect_to(new_session_path) unless current_user
  end

  ##
  # The current user as determined by +session[:user_id]+. Returns nil if
  # the user_id is nil.
  #
  def current_user
    id = session[:user_id]
    return unless id
    @current_user ||= User.find(id)
  rescue ActiveRecord::RecordNotFound
    session[:user_id] = nil
  end
  helper_method :current_user

  ##
  # Cache the Trello board as long as the server (worker) is running. The board
  # is updated so rarely that we can afford to restart the server afterwards.
  #
  def trello_board
    $trello_board ||= @card && @card.board
  end
  helper_method :trello_board


  ##
  # Add extra context to Sentry error reports
  #
  def set_raven_context
    Raven.user_context(id: session[:user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
