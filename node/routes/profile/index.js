// route/profile/index.js

const routes = require('express').Router();

routes.get('/',
  require('connect-ensure-login').ensureLoggedIn(),
  function(req, res) {
    res.render('profile', { user: req.user });
  });

module.exports = routes;
