//Schema for server Friend Finder

var mongoose = require('mongoose'),
	Schema 	 = mongoose.Schema;

var LocationSchema = new Schema ({  
	ID : {type: String, required: true},
	Lat  : {type: String, required: true},
    Lon  : {type: String, required: true},
    Date : {type: String, required: false}
});

LocationSchema.statics.saveLocation = function(location){
	return location.save();
};

var Location = mongoose.model('Location', LocationSchema);

module.exports = Location;
