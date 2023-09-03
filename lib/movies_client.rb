##
# This class responsible to process movies list
require 'themoviedb-api'
require 'uri'
require 'net/http'


class MoviesClient
	def initialize(query, page = 1)
    @query = query
    @page = page.to_i
  end

	def search
		Tmdb::Api.key(ENV['TMDB_API_KEY'])
		Tmdb::Search.movie(@query, page: @page)
	end

  def validate_api_key
		url = URI("https://api.themoviedb.org/3/authentication?api_key=#{ENV['TMDB_API_KEY']}")

		http = Net::HTTP.new(url.host, url.port)
		http.use_ssl = true

		request = Net::HTTP::Get.new(url)

		response = http.request(request)
		JSON.parse(response.read_body)
	end
end