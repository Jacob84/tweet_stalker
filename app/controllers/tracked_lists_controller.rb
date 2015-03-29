# TrackedListsController
class TrackedListsController < AuthenticatedApplicationController
  def index
    show_all = params[:show_all] == 'true'
    service = TrackedListsService.new
    lists = service.get_lists(@current_user)
    lists = lists.select { |l| l.tracked == true } unless show_all
    render json: lists
  end

  def post
    tracker = TrackedListsService.new
    only_tracked = params['_json'].select { |l| l[:tracked] == 'true' }
    identifiers =  only_tracked.map { |l| l[:twitter_list_id] }

    tracker.add_lists(@current_user, identifiers)

    render json: 'ok'.to_json, status: 200
  end
end
