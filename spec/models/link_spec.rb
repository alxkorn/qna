require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should_not allow_value("invalid_url").for(:url) }
  it { should allow_value("https://www.google.com").for(:url) }

  describe 'gist?' do
    let(:question) { create(:question) }
    let(:link_gist) { create(:link, :gist, linkable: question) }
    let(:link_not_gist) { create(:link, linkable: question) }

    it 'should return true if link is a gist' do
      expect(link_gist.gist?).to be_truthy
    end

    it 'should return false if link is not a gist' do
      expect(link_not_gist.gist?).to be_falsey
    end
  end
end
