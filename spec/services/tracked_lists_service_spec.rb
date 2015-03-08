require 'rails_helper'
require 'testing_helpers'
require 'ostruct'

RSpec.describe TrackedListsService do
  include TestingHelpers

  before do
    @lists_retriever = TwitterListRetriever.new
    allow(@lists_retriever).to receive(:lists).and_return([get_test_list(321139), get_test_list(111111)])
    @user_lists_tracker = TrackedListsService.new(@lists_retriever)
  end

  describe 'when getting backed tracked lists' do
    context 'with no backed lists' do
      it 'returns all lists with no tracking' do
        result = @user_lists_tracker.get_lists(1)

        expect(result.length).to be 2
        assert_tracked_list(result[0], 321139, 'name', 11, 22, 'public', false)
        assert_tracked_list(result[1], 111111, 'name', 11, 22, 'public', false)
      end
    end

    context 'with backed lists' do
      it 'returns suitable lists with tracking' do
        TrackedList.create(
          :user_id => 1, :name => 'name',
          :twitter_list_id => 111111, :tracked => true,
          :subscriber_count => 11, :member_count => 22, :mode => 'public')

        result = @user_lists_tracker.get_lists(1)

        expect(result.length).to be 2
        assert_tracked_list(result[1], 321139, 'name', 11, 22, 'public', false)
        assert_tracked_list(result[0], 111111, 'name', 11, 22, 'public', true)
      end
    end
  end

  describe 'when submiting backed lists' do
    context 'with no previous backed lists' do
      it 'inserts the backed list' do
        @user_lists_tracker.add_lists(1, [222])
        tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 222)
        expect(tracked_list.nil?).to be false
      end
    end

    context 'with previous backed lists' do
      it 'inserts and updates backed list' do
        TrackedList.create(:user_id => 1, :twitter_list_id => 111111, :tracked => false)

        @user_lists_tracker.add_lists(1, [111111, 222222])

        all_tracked_lists = TrackedList.find_all_by_user_id(1)
        first_tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 111111)
        second_tracked_list = TrackedList.find_by_user_id_and_twitter_list_id(1, 222222)

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
