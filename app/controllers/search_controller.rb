class SearchController < ApplicationController

BASE_URL = "http://services.homefinder.com/listingServices/search?apiKey=dstkfptrwchc46q5dbm9qs6x"

def call
	logger.info(params[:q])
	url = BASE_URL + "&area=" + params[:q]
	response = RestClient.get(url)	
	puts response
end
end
