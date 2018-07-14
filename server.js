const express = require('express');
const passport = require('passport');
const session = require('express-session');
const Strategy = require('passport-local');
const db = require('./db');

var port = process.env.PORT || 3000;

passport.use(new Strategy(
  function(username, password, cb) {
    db.users.findByUsername(username, function(err, user) {
      if (err) { return cb(err); }
      if (!user) { return cb(null, false); }
      if (user.password != password) { return cb(null, false); }
      return cb(null, user);
    });
  }
));

passport.serializeUser(function(user, cb) {
  cb(null, user.username);
});

passport.deserializeUser(function(username, cb) {
  db.users.findByUsername(username, function (err, user) {
    if (err) { return cb(err); }
    cb(null, user);
  });
});


var app = express();

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
app.use(require('morgan')('combined'));
app.use(require('cookie-parser')());
app.use(require('body-parser').urlencoded({ extended: true }));
app.use(require('express-session')({ secret: 'keyboard cat', resave: false, saveUninitialized: false }));
app.use(passport.initialize());
app.use(passport.session());

// Define routes.
app.get('/',
  function(req, res) {
    res.render('home', { user: req.user });
  });

app.get('/login',
  function(req, res){
    res.render('login');
  });
  
app.post('/login', 
  passport.authenticate('local', { failureRedirect: '/login' }),
  function(req, res) {
    res.redirect('/');
  });
  
app.get('/logout',
  function(req, res){
    req.logout();
    res.redirect('/');
  });

app.get('/profile',
  require('connect-ensure-login').ensureLoggedIn(),
  function(req, res){
    res.render('profile', { user: req.user });
});

app.get('/register',
  function(req, res){
    res.render('register', {
      data: {},
      errors: {}
    });
  });

app.post('/register',
  function(req, res){
    //var user = ?;  // get user post data
    //db.users.addUser(user, function(err) {
    //  if (err != null) {

    //  } else {

   //   }
   // });
    res.render('register', {
      data: req.body,
      errors: {
        username: {
          msg: 'username is required' 
        },
        email: {
          msg: 'email is required'
        },
        password: {
          msg: 'password is required'
        }
      }
    });
  });

app.listen(port);
module.exports = app;
