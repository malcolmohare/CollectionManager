// routes/login.js
const routes = require('express').Router();
const passport = require('passport');


routes.get('/login',
  function(req, res) {
    res.render('login');
  });

routes.post('/login',
  passport.authenticate('local', { failureRedirect: '/login' }),
  function(req, res) {
    res.redirect('/');
  });

module.exports = routes;
