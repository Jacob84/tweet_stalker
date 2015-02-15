class ListTimelineController < ApplicationController
  def timeline
    timeline = Tweet.where(:analyzed => true).sort(:created_at.desc)
    render json: timeline
  end

  def update
    manager = TwitterListManager.new
    analyzer = TwitterListAnalyzer.new

    manager.sync_list_timeline 189546423
    analyzer.process_pending_tweets

    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
