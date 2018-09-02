// routes/logout.js

const routes = require('express').Router();

routes.get('/logout',
  function(req, res) {
    req.logout();
    res.redirect('/');
  });

module.exports = routes;
