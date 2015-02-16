class TrackedListsController < ApplicationController
  def index
    retriever = TwitterListRetriever.new
    render json: retriever.lists
  end
end
