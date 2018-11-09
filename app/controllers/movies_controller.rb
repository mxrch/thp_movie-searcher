class MoviesController < ApplicationController

  def search
    if params[:search]
      @results = SearchMovie.new.perform(params[:search])
      @search = params[:search]
    end
  end

end
