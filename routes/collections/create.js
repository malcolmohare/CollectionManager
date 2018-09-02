// routes/collections/create.js
const routes = require('express').Router();
const validator = require('express-validator');
const { check, validationResult } = require('express-validator/check');
const { matchedData } = require('express-validator/filter');

routes.post('/collection-create', [
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

module.exports = routes;
