FactoryGirl.define do
  factory :user do
    uid { FFaker::Youtube.video_id }
    provider "trello"
    name { FFaker::Name.name }
    oauth_token { ENV['TRELLO_DEVELOPER_KEY'] }
    oauth_secret { ENV['TRELLO_DEVELOPER_SECRET'] }
  end
end
