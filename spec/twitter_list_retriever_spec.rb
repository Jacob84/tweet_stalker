require 'twitter_list_retriever'
require 'ostruct'

LIST_ID = 1
LIST_NAME = 'name'
LIST_URI = 'uri'
LIST_SUSCRIBERCOUNT = 10
LIST_MEMBERCOUNT = 20
LIST_MODE = 'public'

RSpec.describe TwitterListRetriever do
  before do
    @client = double()
    @wrapper = TwitterListRetriever.new(@client)
    allow(@client).to receive(:lists).and_return([get_test_list])
  end

  context 'when getting lists of users' do
    it 'returns a list with the users lists' do
      result = @wrapper.lists()

      list = result[0]

      expect(list.twitter_list_id).to eq LIST_ID
      expect(list.name).to eq LIST_NAME
      expect(list.uri).to eq LIST_URI
      expect(list.subscriber_count).to eq LIST_SUSCRIBERCOUNT
      expect(list.member_count).to eq LIST_MEMBERCOUNT
      expect(list.mode).to eq LIST_MODE
    end
  end

  def get_test_list
    list_hash = {
      :id => LIST_ID,
      :name => LIST_NAME,
      :uri => LIST_URI,
      :subscriber_count => LIST_SUSCRIBERCOUNT,
      :member_count => LIST_MEMBERCOUNT,
      :mode => LIST_MODE
    }

    list = OpenStruct.new(list_hash)
  end
end
