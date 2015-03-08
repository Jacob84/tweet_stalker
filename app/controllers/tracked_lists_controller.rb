class TrackedListsController < ApplicationController
  def index
    show_all = params[:show_all] == 'true'
    service = TrackedListsService.new
    lists = service.get_lists(1)
    if !show_all
      lists = lists.select { |l| l.tracked == true }
    end
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
