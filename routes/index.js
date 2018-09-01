// routes/index.js

const routes = require('express').Router();
const login = require('./login');

routes.get('/',
  function(req, res) {
    res.render('home', { user: req.user });
  });

routes.use('/', login);

module.exports = routes;

