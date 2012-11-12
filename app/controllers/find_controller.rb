class FindController < ApplicationController

BASE_URL = "http://services.homefinder.com/listingServices/search?apiKey=dstkfptrwchc46q5dbm9qs6x"

	def index
		require 'rest_client'
		if (params[:back])
			url = BASE_URL + "&area=" + Rack::Utils.escape(session[:location])
			url = url + "&page=" + String(session[:currentPage])
			if (session[:baths])
				url = url + "&bath=" + session[:baths]
			end
			if (session[:bedrooms])
				url = url + "&beds=" + session[:bedrooms]
			end		
		elsif (params[:nextPage])
			url = BASE_URL + "&area=" + Rack::Utils.escape(session[:location])
			session[:currentPage] +=  1
			url = url + "&page=" + String(session[:currentPage])
			if (session[:baths])
				url = url + "&bath=" + session[:baths]
			end
			if (session[:bedrooms])
				url = url + "&beds=" + session[:bedrooms]
			end

		elsif(params[:prevPage])
			url = BASE_URL + "&area=" + Rack::Utils.escape(session[:location])
			session[:currentPage] -=  1
			url = url + "&page=" + String(session[:currentPage])
			if (session[:baths])
				url = url + "&bath=" + session[:baths]
			end
			if (session[:bedrooms])
				url = url + "&beds=" + session[:bedrooms]
			end
		else			
			logger.info(params[:location])
			if (params[:location])
				session[:location] = params[:location];
				url = BASE_URL + "&area=" + Rack::Utils.escape(params[:location])
				if (params[:baths])
					url = url + "&bath=" + params[:baths]
					session[:baths] = params[:baths]
				else
					session[:baths] = nil
				end
				if (params[:bedrooms])
					url = url + "&beds=" + params[:bedrooms]
					session[:bedrooms] = params[:bedrooms]
				else
					session[:bedrooms] = nil
				end

			else	
				@listings = "noresults"
			end
		end
		puts url
		begin
			response = RestClient.get url	
			parsed_json = JSON.parse(response)
			puts response.code
			if (parsed_json["status"]["code"] == 604)
				@listings = "noresults"
			elsif (parsed_json["status"]["code"] == 606)
				@listings = "badsearch"
			elsif (parsed_json["status"]["code"] == 500)
				@listings = "error"
			elsif (parsed_json["status"]["code"] == 200)
				data = parsed_json["data"]	
				session[:currentPage] = Integer(data["meta"]["currentPage"])
				if (data["meta"]["totalPages"] > 1)				
					if (data["meta"]["currentPage"] >= 1 && data["meta"]["currentPage"] < data["meta"]["totalPages"])
						data["hasMorePages"] = "YES"
					end
					if (data["meta"]["currentPage"] > 1)
						data["hasPrevPages"] = "YES"
					end
				end	
				@listings = data
			else
				@listings = "error"			
			end
		rescue RestClient::ResourceNotFound => e
			@listings = "error"
		rescue RestClient::RequestFailed => e
			@listings = "error"
		end
	
	end
end
