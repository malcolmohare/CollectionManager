// routes/index.js

const routes = require('express').Router();
const login = require('./login');
const logout = require('./logout');
const profile = require('./profile');

routes.get('/',
  function(req, res) {
    res.render('home', { user: req.user });
  });

routes.use('/', login);
routes.use('/', logout);
routes.use('/profile', profile);

module.exports = routes;

