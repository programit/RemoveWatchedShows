# RemoveWatchedShows
Clean up watched TV Shows using Trakt for watched data


Most of the time after I watch a tv show I will not re-watch the show. In this scenario keeping files around on disk is a waste of storage. By keeping trakt of watched status using trakt I can query trakt using a cronjob every hour or even day to find out what shows can now be deleted.

Currently I don't support refreshing trakt auth token or even getting it for the first time from the command line. 

Also files are currently listed but not deleted. Need more testing before I feel confident in deleting files.
