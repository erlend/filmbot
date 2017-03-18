require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#nav_link_to' do
    subject { helper.nav_link_to 'Foo', url }
    let(:url) { '/' }

    it { is_expected.to have_tag 'li.nav-item' do
      with_tag 'a.nav-link', text: 'Foo', href: url
    end }

    context 'when links to current page' do
      let(:url) { '' }

      it { is_expected.to have_tag 'li.nav-item.active' do
        with_tag 'a.nav-link', text: 'Foo(current)'
      end }
    end
  end

end
