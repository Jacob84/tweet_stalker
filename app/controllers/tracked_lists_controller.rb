class TrackedListsController < ApplicationController
  def index
    service = TrackedListsService.new
    lists = service.get_tracked_lists(1)
    render json: lists
  end

  def post
    tracker = TrackedListsService.new
    only_tracked = params['_json'].select { |l| l[:tracked] == "true" }
    identifiers =  only_tracked.map { |l| l[:twitter_list_id] }

    tracker.add_lists(1, identifiers)

    render json: 'ok'
  end
end
