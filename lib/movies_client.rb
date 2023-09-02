##
# This class responsible to process movies list

require 'uri'
require 'net/http'

class MoviesClient
	def self.search(query, page = 1)
		Tmdb::Api.key(ENV['TMDB_API_KEY'])
		Tmdb::Search.movie(query, page: 1)
	end
end