require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  subject { response }

  describe '#require_user!' do
    controller do
      before_action :require_user!

      def index
        head :ok
      end
    end

    before do
      allow(controller).to receive(:current_user) { user }
      get :index
    end

    context 'when user is logged in' do
      let(:user) { double 'User' }

      it { is_expected.to be_success }
    end

    context 'when user is unauthorized' do
      let(:user) { nil }

      it { is_expected.to redirect_to new_session_path }
    end
  end

  describe '#current_user' do
    subject { controller.send :current_user }

    context 'when user is logged in' do
      let(:user) { create :user }
      before { session[:user_id] = user.id }

      it { is_expected.to be_a User }
    end

    context 'when user is unauthorized' do
      before { session[:user_id] = nil }

      it { is_expected.to be nil }
    end
  end
end
