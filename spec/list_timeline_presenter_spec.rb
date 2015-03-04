require 'rails_helper'

RSpec.describe ListTimelinePresenter do

  let(:presenter) { ListTimelinePresenter.new }
  let(:results) { presenter.get_timeline(1, 32192) }

  before do
    Tweet.create(:user_id => 1, :twitter_list_id => 32192, :analyzed => true)
    Tweet.create(:user_id => 1, :twitter_list_id => 32192, :analyzed => false)
    Tweet.create(:user_id => 1, :twitter_list_id => 00001, :analyzed => false)
  end

  describe 'when asking for a tweet' do
    it 'gets analyzed tweets from list' do
      expect(results.count).to be 1
      expect(results.first(:twitter_list_id => 32192).nil?).to be false
    end

    it 'avoids getting tweets from other list' do
      expect(results.first(:twitter_list_id => 00001).nil?).to be true
    end
  end

  after :each do
    Tweet.destroy_all
  end

end
