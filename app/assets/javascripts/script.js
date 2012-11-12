var webStorageSupported = false;
function validate()
{
	var retValue = true;
	if (document.getElementById("location").value == "")
	{
		alert("Location is required!")
		retValue =  false;
	}
	return retValue;
}

function isWebStorageSupported()
{

	if(typeof(Storage)!=="undefined")
  	{
  		webStorageSupported = true;
 	}
}
function saveListingToFavorites(listingId)
{
	localStorage.listings.push(listingId);

}
