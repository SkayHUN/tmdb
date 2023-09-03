# frozen_string_literal: true

require 'movies_client'
require 'dotenv/load'

describe MoviesClient do
  subject(:movies_client) { described_class.new(query, page).search }

  describe '#search' do
    context 'when search by query' do
    	context 'with valid tmdb api key' do
	      context 'and query is empty' do
	        let(:query) { '' }
	        let(:page) { 1 }

	        it 'no movies listed' do
	        	expect(movies_client.page).to eq 1
	      		expect(movies_client.total_pages).to eq 1
	      		expect(movies_client.total_results).to eq 0
	          expect(movies_client.results).to eq([])
	        end
	      end

	      context 'and query is filled' do
	        let(:query) { 'finding nemo' }
	        let(:page) { 1 }

	        it 'returns movies related to the keyword' do
	      		expect(movies_client.page).to eq 1
	      		expect(movies_client.total_pages).to be_present
	      		expect(movies_client.total_results).to be_present
	      		expect(movies_client.results).to be_present
	      		expect(movies_client.results).not_to eq([])
	        end
	      end

	      context 'pagination is used in case of more than 20 results' do
	        let(:query) { 'action'}
	        let(:page) { 2 }

	        it 'returns the results from the tmdb page 2 related to the keyword' do
	      		expect(movies_client.page).to eq 2
	      		expect(movies_client.total_pages).to be_present
	      		expect(movies_client.total_results).to be_present
	      		expect(movies_client.results).to be_present
	      		expect(movies_client.results).not_to eq([])
	        end
	      end
	    end

	    context 'with invalid tmdb api key' do
	    	context 'and query is filled' do
	    		subject(:movies_client) { described_class.new(query, page).validate_api_key }
	        let(:query) { 'finding nemo' }
	        let(:page) { 1 }

	        it 'returns movies related to the keyword' do
	        	stub_const('ENV', {'TMDB_API_KEY' => 'asdf12312asd'})
	      		expect(movies_client['success']).to eq false
	        end
	      end
	    end
    end
  end
end
