class ListTimelineController < ApplicationController
  def timeline
    presenter = ListTimelinePresenter.new
    render json: presenter.get_timeline(1, params[:id].to_i)
  end

  def update
    manager = TwitterListTimelineDownloader.new
    analyzer = TwitterListAnalyzer.new

    manager.sync_list_timeline(1, 189546423)
    analyzer.process_pending_tweets

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
