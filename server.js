const express = require('express');
const passport = require('passport');
const session = require('express-session');
const Strategy = require('passport-local');
const db = require('./db');
const validator = require('express-validator');
const cookieParser = require('cookie-parser');
const flash = require('express-flash');
const bcrypt = require('bcrypt');

const middleware = [
  validator(),
  cookieParser(),
  flash()
];

const { check, validationResult } = require('express-validator/check');
const { matchedData } = require('express-validator/filter');

var port = process.env.PORT || 3000;

passport.use(new Strategy(
  function(username, password, cb) {
    db.users.findByUsername(username, function(err, user) {
      if (err) { return cb(err); }
      if (!user) { return cb(null, false); }
      bcrypt.compare(password, user.password, function(err, res) {
        if (res) {
          return cb(null, user);
        } else {
          return cb(null, false);
        }
      });
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
app.use(require('body-parser').urlencoded({ extended: true }));
app.use(require('express-session')({ secret: 'keyboard cat', resave: false, saveUninitialized: false }));
app.use(passport.initialize());
app.use(passport.session());
app.use(middleware);

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

app.get('/collections',
  function(req, res) {
    res.render('collections', {
      data: {},
      errors: {}
    }); 
  });

app.get('/collections/:collectionType',
  function(req, res) {
    res.render('collectiontype', {
      data:  {},
      errors: {}
    });
  });

app.get('/collections/:collectionType/:collectionName',
  function(req, res) {
    res.render('collection', {
      data: {},
      errors: {}
    });
  });



app.post('/collection-create', [
  check('collectionType')
    .isLength({min:1})
    .withMessage('collection type is required')
    .trim(),
  check('collectionName')
    .isLength({min:1})
    .withMessage('collection name is required')
    .trim()
  ],
  function(req, res) {
    const errors = validationResult(req);
    const data = matchedData(req);
    errors.operation = "create";
    if(!errors.isEmpty()) {
      res.render('collections', {
        data: data,
        errors: errors
      });
    }
    db.collections.createCollection(data, function(err, result) {
      if (err != null) {
        res.render('/collections',
          {
            data: data,
            errors: { create : { msg : err.message }}
          });
      } else {
        res.redirect('/collections/' + data.collectionType + '/' + data.collectionName);
      }
    });
  });

app.get('/register',
  function(req, res){
    res.render('register', {
      data: {},
      errors: {}
    });
  });

app.post('/register', [
    check('username')
      .isLength({min:1, max:32})
      .withMessage('Username is required')
      .trim(),
    check('email')
      .isEmail()
      .withMessage('Email is required')
      .trim()
      .normalizeEmail(),
    check('password')
      .isLength({min:1, max:16})
      .withMessage('Password is required')
      .trim()
  ],
  function(req, res){
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      res.render('register', {
        data: req.body,
        errors: errors.mapped()
      });
    }

    const data = matchedData(req);
    let hash = bcrypt.hashSync(data.password, 10);
    
    data.password = hash;
    console.log('Sanitized:', data);

    db.users.addUser(data, function(err) {
      if (err) {
        data.password = "";
        res.render('register', {
          data: data,
          errors: { registration: { msg: err.message }}
        });
      } else {
        req.flash('success', 'Thanks for registering!');
        res.redirect('/');
      }
    });

  });

app.listen(port);
module.exports = app;
