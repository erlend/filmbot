require 'rails_helper'

RSpec.feature "Logouts", type: :feature, vcr: { cassette_name: 'raffle' } do

  scenario "User logs out" do
    sign_in

    click_link 'Sign Out'

    expect(page).to have_content 'Unauthorized'
    expect(current_path).to eq new_session_path
  end

end
