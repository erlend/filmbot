module AuthenticationMacros
  module Feature
    def sign_in(user = nil)
      user ||= create :user
      visit '/'
      OmniAuth.config.mock_auth[:trello] =
        OmniAuth::AuthHash.new user.slice(:provider, :uid).merge(
          info: {
            name: user.name
          },
          credentials: {
            token: user.oauth_token,
            secret: user.oauth_secret
          })
      click_link 'Login with Trello'
    end
  end

  module Controller
    def sign_in(user = nil)
      user ||= create :user
      allow(controller).to receive(:current_user) { user }
    end
  end
end

RSpec.configure do |config|
  config.before(:each, type: :feature) { OmniAuth.config.test_mode = true }

  config.include AuthenticationMacros::Feature,    type: :feature
  config.include AuthenticationMacros::Controller, type: :controller
end
