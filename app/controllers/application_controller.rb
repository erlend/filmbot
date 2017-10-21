class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_raven_context

  private

  ##
  # Add extra context to Sentry error reports
  #
  def set_raven_context
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
