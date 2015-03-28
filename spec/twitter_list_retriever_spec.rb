require 'rails_helper'
require 'ostruct'

LIST_ID = 1
LIST_NAME = 'name'
LIST_URI = 'uri'
LIST_SUSCRIBERCOUNT = 10
LIST_MEMBERCOUNT = 20
LIST_MODE = 'public'

RSpec.describe TwitterListRetriever do
  let(:user) { ApplicationUser.new(_id: 1) }
  let(:wrapper) { prepare_wrapper }

  context 'when getting lists of users' do
    it 'returns a list with the users lists' do
      result = wrapper.lists(user)

      list = result[0]

      assert_list list
    end
  end

  def assert_list(list)
    expect(list.list_id).to eq LIST_ID
    expect(list.name).to eq LIST_NAME
    expect(list.uri).to eq LIST_URI
    expect(list.subscriber_count).to eq LIST_SUSCRIBERCOUNT
    expect(list.member_count).to eq LIST_MEMBERCOUNT
    expect(list.mode).to eq LIST_MODE
  end

  def prepare_wrapper
    client = double
    allow(client).to receive(:lists).and_return([test_list])
    TwitterListRetriever.new(client)
  end

  def test_list
    list_hash = {
      id: LIST_ID,
      name: LIST_NAME,
      uri: LIST_URI,
      subscriber_count: LIST_SUSCRIBERCOUNT,
      member_count: LIST_MEMBERCOUNT,
      mode: LIST_MODE
    }

    list = OpenStruct.new(list_hash)

    list
  end
end
