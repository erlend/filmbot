require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.from_omniauth' do
    subject { described_class.from_omniauth auth_hash }
    let(:auth_hash) { OmniAuth::AuthHash.new(uid: user.uid,
                                             provider: user.provider,
                                             info: { name: user.name },
                                             credentials: {}) }

    context 'with valid auth hash' do
      let(:user) { build_stubbed :user }

      it { is_expected.to be_a User }
      it { is_expected.to have_attributes(uid: user.uid,
                                          provider: user.provider,
                                          name: user.name) }
    end

    context 'when user already exist' do
      let(:user) { create :user }

      it { is_expected.to be_a User }
    end

    context 'with invalid auth hash' do
      let(:auth_hash) { :invalid_credentials }

      it { is_expected.to be nil }
    end
  end

  describe '.bot' do
    subject { described_class.bot }

    context 'when bot exists' do
      let!(:bot) { create :user, webhook_id: 'foo' }

      it { is_expected.to eq bot }
    end

    context 'when bot does not exist' do
      it { is_expected.to be nil }
    end
  end

  describe '.moviefy_cards' do

  end

end
