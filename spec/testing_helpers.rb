require 'rails_helper'

module TestingHelpers
  def get_test_list(list_id)
    list_hash = {
      :list_id => list_id,
      :name => 'name',
      :uri => 'uri',
      :subscriber_count => 11,
      :member_count => 22,
      :mode => 'public'
    }

    list = OpenStruct.new(list_hash)

    return list
  end

  def assert_tracked_list(tracked_list,
      twitter_list_id, name, subscriber_count,
      member_count, mode, tracked)

      expect(tracked_list.twitter_list_id).to be twitter_list_id
      expect(tracked_list.name).to eq name
      expect(tracked_list.subscriber_count).to be subscriber_count
      expect(tracked_list.member_count).to be member_count
      expect(tracked_list.mode).to eq mode
      expect(tracked_list.tracked).to be tracked
  end
end
