//npm install express in local node_modules
//npm install ejs (no explicit require is needed because express will take care
//path module comes default in node js installation
//Create a file index.ejs under views folder which can be an html file with <%= new Date(); %>
//Rendering a View
//npm install -g bower - Bower is just like npm which is used for installing the front end js modules(CSS and JS and Jquery for browser)
//type bower (will display the list of commands) bower i bootstrap
//JADE is similar to EJS just that syntax would vary
//morgan is the logger
var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var app = express();
app.set('view engine','ejs');
app.set('views', path.join(__dirname, 'views');
//Register a middleware to the express application
//We need find the list of middleware that express supports
//expressjs.com. In case you need to parse the information from the body
//We need to do npm install body-parser and do require
//Express uses middleware to augment applications with reusable behavior
//For Authentication, users use passport.js middleware
app.use(bodyParser());
app.use(cookieParser());
//Any external Client CSS,Jquery you use, express will not be able to recongnise,
//So register this middleware important
app.use(express.static(path.join(__dirname, 'bower_components')));

var todoItems = [
	   	{id: 1, desc:'foo' },
	   	{id: 2, desc:'bar' },
	   	{id: 3, desc:'baz' },
	   ];
app.get('/', function(req, res) {
   res.render('index', {
	   title: 'My app',
	   items: todoItems
	   });
});

app.post('/add', function(req,res) {
	var newItem = req.body.newItem;
	todoItems.push({
		id: todoItems.length + 1,
		desc: newItem
	});
	res.redirect('/'); // This will refresh the / page on the browser
});

//Instead of the above code, we are using the router middleware Important again
//Dyamically routing
//app.use(require('./todos')); default would looked in from node_modules
//app.use('/api', require('todos')); URL appended will be localhost:1337/api/add or /api/

app.listen(1337, function() {
   console.log('app ready listening on port 1337);
});

//Example How to write Logging Middleware
//app.use(function(req, res) {
//	console.log(req.method + ' ' + req.url + ' ' + +(new Date()));
//    next(); Important because the application will not hang forever
//});
//Error Handler Middleware
//app.use(function(err, req, res, next) {
//	res.status(err.status || 500);
//	res.render('error', {
//		message: err.message,
//		error: err
//});
//});
