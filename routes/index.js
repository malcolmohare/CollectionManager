// routes/index.js

const routes = require('express').Router();
const login = require('./login');
const logout = require('./logout');
const profile = require('./profile');
const collections = require('./collections');
const register = require('./register');

routes.get('/',
  function(req, res) {
    res.render('home', { user: req.user });
  });

routes.use('/', login);
routes.use('/', logout);
routes.use('/', register);
routes.use('/profile', profile);
routes.use('/collections', collections);


module.exports = routes;

