var app = Application.currentApplication()
app.includeStandardAdditions = true


var tracks = Application('iTunes').selection()

var kinds = new Set();
var disallow = new Set();
for (var item of ["spring", "eng", "mbl", "great", "ps2", "Winter", "nice", "ex'",
                  "latin", "spring 2010", "Winter 2011", "Great", "bg", "dq", "zmain"]){
	disallow.add(item);
}

mapping = {"in" : "yInsert" }

function rejector (x){
	if (!x){
		return false;
	}else{
		return ( !disallow.has(x));
	}
}

function changer(x){
	if (x in mapping){
		return mapping[x];
	}else{
		return x;
	}
}

for (var track of tracks) {
	if (track.grouping().indexOf(',') !== -1  ){
		parts =  track.grouping().split(',');
		parts = parts.map( function (x) { return x.trim() }  );
		parts = parts.map( changer );		
		parts = parts.filter( rejector );

		
		if (parts.length >0){
			for (var part of parts){ kinds.add(part); }
			new_grouping = parts.sort().map(function(x){return x + "," } ).join(' ')
			
			if (track.grouping() != new_grouping){
				track.grouping = new_grouping;
			}
			
		}
		
	}	
}


for (var item of kinds) console.log(item);

