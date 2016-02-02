require 'net/http'
require 'uri'
require 'json'

def getWatchedTvShows
	uri = URI.parse("https://api-v2launch.trakt.tv/sync/watched/shows")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	request = Net::HTTP::Get.new(uri.request_uri)
	request["Authorization"] = "Bearer USERS_BEARER_TOKEN_HERE"
	request["Content-Type"] = "application/json"
	request["trakt-api-version"]  = "2"
	request["trakt-api-key"] = "TRAKT_API_KEY_HERE"

	response = http.request(request)
	return response.body;
end

def getFilesInDir
	showsOnDisk = Hash.new
	# Location where files are stored
	Dir.entries('../torrents/data/tv').each do |x|
		tempMatch = /^(?<showname>.*)[\.|\s]+S(?<season>\d{2})E(?<episode>\d{2})/.match(x)
		if tempMatch != nil then
			showname = tempMatch["showname"].gsub(/\./, " ")
			season = tempMatch["season"].to_i
			episode = tempMatch["episode"].to_i
			if showsOnDisk[showname] == nil then
				showsOnDisk[showname] = Hash.new
			end
			
			if showsOnDisk[showname][season] == nil then
				showsOnDisk[showname][season] = Hash.new
			end

			showsOnDisk[showname][season][episode] = tempMatch.string
		end
	end

	return showsOnDisk
end

showsOnDisk = getFilesInDir()

# A hash of show name to index into the json blob
# useful for quickly finding a show based on name
showsOnTrakt = Hash.new
watched = getWatchedTvShows()
json = JSON.parse(watched)
loc = 0
json.each do |x|	
	showsOnTrakt[x["show"]["title"].gsub(/\'/, "")] = loc;
	loc = loc + 1
end


showsOnDisk.keys.each do |showname|
	showsOnDisk[showname].keys.each do |season|
		# Check to see if the season exists in the array. If it doesn't exist then it means
		# that we haven't watched one episod ein the season yet.
		if json[showsOnTrakt[showname]]["seasons"][season - 1] == nil then
			next
		end
		showsOnDisk[showname][season].keys.each do |episode|
			# Check to see if the episode exists in the array. If it doesn't exist then it means
			# that the episode hasn't been watched yet.
			if json[showsOnTrakt[showname]]["seasons"][season - 1]["episodes"][episode - 1] == nil then
				next
			end
				puts showname + " " + season.to_s + " " + episode.to_s + "        " + showsOnDisk[showname][season][episode]
		end
	end
end
