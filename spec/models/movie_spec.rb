require 'rails_helper'

RSpec.describe Movie, type: :model, vcr: { cassette_name: 'with_movie' } do
  let(:movie) { described_class.find 'tt0451279' }

  describe '.find' do
    context 'with existing movie' do
      subject { movie }

      it { is_expected.to be_a Movie }
    end

    context 'without movie', vcr: { cassette_name: 'without_movie' } do
      subject { described_class.find 'tt0foo' }

      it { is_expected.to be nil }
    end
  end

  describe '#backdrop_url' do
    subject { movie.backdrop_url }

    it { is_expected.to eq 'https://image.tmdb.org/t/p/w500/iV6w99lpgEO23S8f80wCKLt1eCq.jpg' }
  end

  describe '#poster_url' do
    subject { movie.poster_url }

    it { is_expected.to eq 'https://image.tmdb.org/t/p/w500/2Pq1CoqB8aF4XHI5DDqqABA94Rt.jpg' }
  end

end
