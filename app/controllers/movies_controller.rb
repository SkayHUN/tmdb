require 'movies_client'

class MoviesController < ApplicationController
  def index
    @query = params['default-search']
    @page = params['page'] || 1
    cache_key = "#{@query}_#{@page}" 

    if @query
      if Rails.cache.fetch(cache_key).present?
        @fetched_from = 'our server'
        session[:cache_hit_counter] = session[:cache_hit_counter].to_i + 1 if session[:cache_hit_counter]
      else
        @fetched_from = '3rd party API'
        session[:cache_hit_counter] = 0
      end

      fetched_data = Rails.cache.fetch(cache_key, expires_in: 2.minutes) do
        MoviesClient.search(@query, @page.to_i)
      end

      @movies = fetched_data.results
    end

    # for pagination
    @total_pages = fetched_data&.total_pages
    @current_page = fetched_data&.page
    @total_results = fetched_data&.total_results

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
