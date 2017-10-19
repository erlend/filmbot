require 'rails_helper'

RSpec.describe CommandsController, type: :controller do

  describe 'POST #create' do
    before do
      ActiveJob::Base.queue_adapter = :test
      post :create, params: command_params
    end

    context 'without valid slack token' do
      let(:command_params) {{ token: 'notvalid' }}

      it { is_expected.to have_attributes status: 403 }
      specify { expect(CommandJob).not_to have_been_enqueued }
    end

    context 'with valid slack token' do
      let(:command_params) {{ token: ENV['SLACK_SLASH_COMMAND_TOKEN'] }}

      it { is_expected.to have_attributes status: 201 }
      specify { expect(CommandJob).to have_been_enqueued }
    end
  end

end
