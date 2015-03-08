require 'rails_helper'

RSpec.describe ListTimelineService do

  let(:manager)   { double() }
  let(:analyzer)  { double() }
  let(:service)   { ListTimelineService.new(manager, analyzer) }
  let(:results)   { service.get_timeline(1, 32192) }

  before do
    allow(manager).to receive(:sync_list_timeline)
    allow(analyzer).to receive(:process_pending_tweets)

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

  describe 'when updating a list' do
    it 'downloads and processes timeline' do
      service.update_timeline(1, 32192)
      expect(manager).to have_received(:sync_list_timeline)
      expect(analyzer).to have_received(:process_pending_tweets)
    end
  end

  after :each do
    Tweet.destroy_all
  end

end
