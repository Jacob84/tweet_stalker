class TrackedListsController < ApplicationController
  def index
    retriever = TwitterListRetriever.new
    render json: retriever.lists
  end

  def post
    tracker = UserListsTracker.new
    only_tracked = params['_json'].select { |l| l[:tracked] == "true" }
    identifiers =  only_tracked.map { |l| l[:twitter_list_id] }

    tracker.add_lists(1, identifiers)

    render json: 'ok'
  end
end
