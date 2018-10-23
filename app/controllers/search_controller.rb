class SearchController < ApplicationController

  def index
    respond_with @results = Search.query(params[:quesry], params[:condition])
  end
end
