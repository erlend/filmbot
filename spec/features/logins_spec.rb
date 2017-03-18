require 'rails_helper'

RSpec.feature "Logins", type: :feature, vcr: { cassette_name: 'raffle' } do
  scenario "User signs in with Trello" do
    visit '/'
    mock_auth name: 'Foo'

    click_link 'Login with Trello'

    expect(page).to have_content 'movie was randomly selected'
  end

  def mock_auth(info)
    OmniAuth.config.mock_auth[:trello] = OmniAuth::AuthHash.new(
      provider: 'trello',
      uid: '12345',
      info: info,
      credentials: {
        token: ENV['TRELLO_DEVELOPER_KEY'],
        secret: ENV['TRELLO_DEVELOPER_SECRET']
      }
    )
  end
end
