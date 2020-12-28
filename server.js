const express = require('express');
const passport = require('passport');
const session = require('express-session');
const Strategy = require('passport-local');
const db = require('./db');
const validator = require('express-validator');
const cookieParser = require('cookie-parser');
const flash = require('express-flash');
const uuid = require('uuid/v4');
const routes = require('./routes');
var CognitoStrategy = require('passport-cognito')

const middleware = [
  validator(),
  cookieParser(),
  flash()
];

const { check, validationResult } = require('express-validator/check');
const { matchedData } = require('express-validator/filter');

var port = process.env.PORT || 3000;

passport.use(new CognitoStrategy({
    userPoolId: 'us-east-1_33nLW2pYv',
    clientId: '4ifb9f6ld81cnlpnggt49jmns6',
    region: 'us-east-1'
  },
  function(accessToken, idToken, refreshToken, user, cb) {
    // TODO: not sure why this function exists
    cb(null, user);
  }
));

passport.serializeUser(function(user, cb) {
  cb(null, {username: user.username, sub: user.sub});
});

passport.deserializeUser(function(user, cb) {
  cb(null, user);
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

// Attach routes.
app.use('/', routes);

app.get('/items',
  function(req, res) {
    res.render('items', {
      data: {},
      errors: {}
    });
  });


app.get('/items/:itemId',
  function(req, res) {
    res.render('item', {
      data: {},
      errors: {}
    });
  });

app.post('/item-create', [
  check('itemName')
    .isLength({min:1})
    .withMessage('item  name is required')
    .trim()
  ],
  function(req, res) {
    const errors = validationResult(req);
    const data = matchedData(req);
    errors.operation = "create";
    if(!errors.isEmpty()) {
      res.render('items', {
        data: data,
        errors: errors
      });
    }
    data.itemId = uuid();
    db.items.createItem(data, function(err, result) {
      if (err != null) {
        res.render('items',
          {
            data: data,
            errors: { create : { msg : err.message }}
          });
      } else {
        db.elasticsearch.putItem(data, function(err, result) {
          res.redirect('/items/' + data.itemId);
        });
      }
    });
  });

app.post('/item-search', [
  check('itemName')
    .isLength({min:1})
    .withMessage('item  name is required')
    .trim()
  ],
  function(req, res) {
    const data = matchedData(req);
    db.elasticsearch.searchItem(data.itemName, function(err, result) {
      res.render('item-search-result',
        { data: result,
          errors : {} }
      );
    }); 
  });

app.listen(port);
module.exports = app;
