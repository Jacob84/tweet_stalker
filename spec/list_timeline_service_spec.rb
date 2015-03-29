require 'rails_helper'

RSpec.describe ListTimelineService do
  let(:manager)   { double }
  let(:analyzer)  { double }
  let(:service)   { ListTimelineService.new(manager, analyzer) }
  let(:user)      { ApplicationUser.new(_id: 1) }
  let(:results)   { service.get_timeline(user, 321_92) }

  before do
    allow(manager).to receive(:sync_list_timeline)
    allow(analyzer).to receive(:process_pending_tweets)

    Tweet.create(user_id: 1, twitter_list_id: 321_92, analyzed: true)
    Tweet.create(user_id: 1, twitter_list_id: 321_92, analyzed: false)
    Tweet.create(user_id: 1, twitter_list_id: 000_01, analyzed: false)
  end

  describe 'when asking for a tweet' do
    it 'gets analyzed tweets from list' do
      expect(results.count).to be 1
      expect(results.first(twitter_list_id: 321_92).nil?).to be false
    end

    it 'avoids getting tweets from other list' do
      expect(results.first(twitter_list_id: 000_01).nil?).to be true
    end
  end

  describe 'when updating a list' do
    it 'downloads and processes timeline' do
      service.update_timeline(user, 321_92)
      expect(manager).to have_received(:sync_list_timeline).with(user, 321_92)
      expect(analyzer).to have_received(:process_pending_tweets).with(user)
    end
  end

  after :each do
    Tweet.destroy_all
  end
end
