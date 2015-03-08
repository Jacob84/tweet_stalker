class ListTimelineController < ApplicationController
  def timeline
    presenter = ListTimelineService.new
    render json: presenter.get_timeline(1, params[:id].to_i)
  end

  def update
    timeline = ListTimelineService.new
    timeline.update_timeline(1, 189546423)
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
