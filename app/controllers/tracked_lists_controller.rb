class TrackedListsController < AuthenticatedApplicationController
  def initialize
    @service = TrackedListsService.new
  end

  def index
    show_all = params[:show_all] == 'true'
    lists = @service.get_lists(@current_user)
    lists = lists.select { |l| l.tracked == true } unless show_all
    render json: lists
  end

  def post
    lists_hash = params['_json'].map { |l| build_list_hash(l) }
    @service.add_lists(@current_user, lists_hash)
    render json: 'ok'.to_json, status: 200
  end

  private

  def build_list_hash(l)
    { id: l[:twitter_list_id], tracked: l[:tracked] }
  end
end
