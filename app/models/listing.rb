class Listing < ActiveResource::Base
	self.site = "http://services.homefinder.com/listingServices/search?apiKey=dstkfptrwchc46q5dbm9qs6x"
	self.element_name = "listings"
	self.format = :json
end
