/**
 * Created by Zachariah on 3/22/2016.
 */

var express = require('express'),
    path = require('path'),
    bodyParser = require('body-parser'),
    logger = require('morgan'),
    http = require('http'),
    mongoose = require('mongoose'),
    routes = require('./routes'),
    app = express();


app.use(logger('Developer')); //Developer logger

app.use(bodyParser.json()); //Parse response body into JSON
app.use(bodyParser.urlencoded({extended: true}));


app.use('/', routes);


app.listen(80, function () {
    console.log('Server listening on port 80.');
});

mongoose.connect('mongodb://localhost/Locations', function(err) {

    if (err)
        return handleError(err);
    else
        var db = mongoose.connection;

    console.log("Connnected to database: Locations");
});



