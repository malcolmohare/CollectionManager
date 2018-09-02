// routes/collections/index.js
const routes = require('express').Router();
const create = require('./create');

routes.use('/', create);

routes.get('/',
  function(req, res) {
    res.render('collections', {
      data: {},
      errors: {}
    });
  });

routes.get('/:collectionType',
  function(req, res) {
    res.render('collectiontype', {
      data: {},
      errors: {}
    });
  });

routes.get('/:collectionType/:collectionName',
  function(req, res) {
    res.render('collection', {
      data: {},
      errors : {}
    });
  });

module.exports = routes;
