var app = Application.currentApplication()
app.includeStandardAdditions = true

var track_key = function(track){
	var track_num = track.trackNumber() 
    var disc_num  = track.discNumber() 
	return "" + disc_num + "-" + track_num 
}

var tracks = Application('iTunes').selection()

var groups = new Map();
var pcs = new Map();
var score = new Map();
var comments = new Map();



for (var track of tracks) {
	var key = track_key(track);
	
	if (track.grouping()){
		groups.set(key , track);
	}
	
	if (pcs.has(key)){
		var cur = pcs.get(key);
		if (track.playedCount() > cur){
			pcs.set(key, track.playedCount());
		}
	}else{
		pcs.set(key, track.playedCount());	
	}
	
	if (score.has(key)){
		var cur = score.get(key);
		if (track.rating() > cur){
			score.set(key, track.rating());
		}
	}else{
		score.set(key, track.rating());	
	}	
	
	if ( track.comment() &&  ! comments.has(key)){
		comments.set(key,track.comment())
	}	
	
}


for (var track of tracks) {
	var key = track_key(track)

	if ( groups.has(key) ){
		new_group = groups.get(key).grouping()
		if (track.grouping() != new_group){
			track.grouping = new_group
		}
	}

	if (pcs.has(key)){
		var val = pcs.get(key);
		if (track.playedCount() < val){
			track.playedCount = val
		}
	}
	
	if (score.has(key)){
		var val = score.get(key);
		if (track.rating() < val){
			track.rating = val;
		}
	}

	
	if ( comments.has(key) ){
		new_comment = comments.get(key)
		if (track.comment() != new_comment){
			track.comment = new_comment
		}
	}

	
}
