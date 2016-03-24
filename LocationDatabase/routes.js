/**
 * Created by Zachariah on 3/22/2016.
 *
 *  Routes for Post, Get, and Put
 */

var express = require('express'),
	router = express.Router(),
	path = require('path'),
    Q = require('q'),
    exec = require('child-process-promise').exec;

var Location = require('./schema.js');


router.get('/', function(req, res) {
    res.sendFile(path.join(__dirname, 'views', 'index.html'));
});


router.get('/GET/Location', function(req, res){
    
    console.log("/Get/Location");
    
    //Create promise to find all Locations
	var promise = Location.find({}).exec();

	//Resolve step: Returns panel ids found by query
	promise.then(function(locations) {

			var locationsArray = [];

			locations.forEach(function(location) {
				locationsArray.push(location);
			});
            
            console.log(locationsArray);
			res.json(locationsArray);
		}) //Catch step: catch any arror thrown by promise.
		.catch(function(err) {
			res.json({
				error: err.message
			});
		});
});

//Allows user to find friends by id instead of grabbing all locations in database. Will be implemented in the future.
router.get('/GET/Location/:id', function(req, res) {
});

router.post('/POST/Location', function(req, res) {

	//var User = req.body.ID;
    //console.log(req.body);
    console.log("/POST/Location");
    
    var data = new Location (req.body);
    
    //console.log(data);
    
   	Location.saveLocation(data).then(function(result){
			res.json({
				location: result
			});
		}).catch(function(error) {
			res.json({
				error: error.message
			});
		});
});

module.exports = router;