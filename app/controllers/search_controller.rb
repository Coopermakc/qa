require 'pry'
class SearchController < ApplicationController

  def index
    #respond_with @results = Search.query(params[:query], params[:condition])
    if params[:query].present?
      page = params[:page] || 1
      @searching = Search.new.search(params[:query], page)
    else
      @searching = nil
    end
  end
end
