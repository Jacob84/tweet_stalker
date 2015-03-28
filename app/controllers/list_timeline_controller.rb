# ListTimelineController
class ListTimelineController < AuthenticatedApplicationController
  def timeline
    presenter = ListTimelineService.new
    render json: presenter.get_timeline(@current_user, params[:id].to_i)
  end

  def update
    timeline = ListTimelineService.new
    timeline.update_timeline(@current_user, params[:id].to_i)
    render nothing: true, status: 200, content_type: 'text/html'
  end
end
