require 'rails_helper'

RSpec.describe User, type: :model do

  describe '.bot' do
    subject { described_class.bot }

    it { is_expected.to be User.instance }
    end

  describe '.moviefy_cards' do

  end

end
