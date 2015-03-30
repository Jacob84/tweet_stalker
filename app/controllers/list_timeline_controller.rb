class ListTimelineController < AuthenticatedApplicationController
  def initialize
    @service = ListTimelineService.new
  end

  def timeline
    render json: @service.get_timeline(@current_user, params[:id].to_i)
  end

  def update
    @service.update_timeline(@current_user, params[:id].to_i)
    render nothing: true, status: 200, content_type: 'text/html'
  end
end
