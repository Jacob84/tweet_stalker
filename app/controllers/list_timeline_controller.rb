class ListTimelineController < ApplicationController
  def timeline
    timeline = Tweet.where(:analyzed => true).sort(:created_at.desc)
    render json: timeline
  end
end
