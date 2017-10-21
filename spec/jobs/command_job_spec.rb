require 'rails_helper'

RSpec.describe CommandJob, type: :job, vcr: { cassette_name: 'command_job' } do
  describe '#perform' do
    subject { CommandJob.perform_now params }
    let(:params) {{ response_url: 'response.url.slack' }}
    before { stub_request :post, params[:response_url] }

    it { is_expected.to have_attributes code: 200 }
  end
end
