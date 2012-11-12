class DetailController < ApplicationController

BASE_URL = "http://services.homefinder.com/listingServices/details?apiKey=dstkfptrwchc46q5dbm9qs6x"

	def show
		require 'rest_client'
		logger.info(params[:id])
		url = BASE_URL + "&id=" + params[:id]
		begin
			response = RestClient.get url
			parsed_json = JSON.parse(response)
			puts response
			puts response.code
			if (response.code != 200)
				@listings = "error"
			else
				data = parsed_json["data"]
				puts data
				@listing = data["listing"]
			end
		rescue RestClient::ResourceNotFound => e
			@listing = "error"
		rescue RestClient::RequestFailed => e
			@listing = "error"
		end
	
	end
end
