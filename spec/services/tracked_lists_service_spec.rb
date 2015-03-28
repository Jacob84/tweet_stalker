require 'rails_helper'
require 'testing_helpers'
require 'ostruct'

RSpec.describe TrackedListsService do
  include TestingHelpers

  let(:lists_retriever) {
    lists_retriever = TwitterListRetriever.new
    allow(lists_retriever).to receive(:lists).and_return([
      get_test_list(123), get_test_list(456)]
    )
    lists_retriever
  }

  let(:user_lists_tracker) { TrackedListsService.new(lists_retriever) }

  let(:user) { ApplicationUser.new(id: 1) }

  describe 'when getting backed tracked lists' do
    context 'with no backed lists' do
      it 'returns all lists with no tracking' do
        result = user_lists_tracker.get_lists(user)

        expect(result.length).to be 2
        assert_tracked_list(result[0], 123, 'name', 11, 22, 'public', false)
        assert_tracked_list(result[1], 456, 'name', 11, 22, 'public', false)
      end
    end

    context 'with backed lists' do
      it 'returns suitable lists with tracking' do
        TrackedList.create(
          user_id: 1,
          name: 'name',
          twitter_list_id: 456,
          tracked: true,
          subscriber_count: 11,
          member_count: 22,
          mode: 'public')

        result = user_lists_tracker.get_lists(user)

        expect(result.length).to be 2
        assert_tracked_list(result[1], 123, 'name', 11, 22, 'public', false)
        assert_tracked_list(result[0], 456, 'name', 11, 22, 'public', true)
      end
    end
  end

  describe 'when submiting backed lists' do
    context 'with no previous backed lists' do
      it 'inserts the backed list' do
        user_lists_tracker.add_lists(user, [222])
        tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 222)
        expect(tracked_list.nil?).to be false
      end
    end

    context 'with previous backed lists' do
      it 'inserts and updates backed list' do
        TrackedList.create(user_id: 1, twitter_list_id: 456, tracked: false)

        user_lists_tracker.add_lists(user, [456, 222_222])

        all_tracked_lists = TrackedList.find_all_by_user_id(1)
        first_tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 456)
        second_tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 222_222)

        expect(all_tracked_lists.length).to be 2
        expect(first_tracked_list.tracked).to be true
        expect(second_tracked_list.tracked).to be true
      end
    end
  end

  after :each do
    TrackedList.destroy_all
  end
end
