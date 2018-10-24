require 'pry'
class SearchController < ApplicationController

  def index
    respond_with @results = Search.query(params[:query], params[:condition])
  end
end
