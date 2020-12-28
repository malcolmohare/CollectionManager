const routes = require('express').Router();
const validator = require('express-validator');
const { check, validationResult } = require('express-validator/check');
const { matchedData } = require('express-validator/filter');

global.fetch = require('node-fetch');
global.navigator = () => null;

const AmazonCognitoIdentity = require('amazon-cognito-identity-js');
const poolData = {
   UserPoolId: "us-east-1_33nLW2pYv",
   ClientId: "4ifb9f6ld81cnlpnggt49jmns6"
};
const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);

var register = function (body, callback) {
   var name = body.username;
   var email = body.email;
   var password = body.password;
   var attributeList = [];
   
   attributeList.push(new AmazonCognitoIdentity.CognitoUserAttribute({ Name: "email", Value: email }));

   userPool.signUp(name, password, attributeList, null, function (err, result) {
     if (err)
         callback(err);

     var cognitoUser = result.user;
     callback(null, cognitoUser);
   })
}

routes.get('/register',
  function(req, res){
    res.render('register', {
      data: {},
      errors: {}
    });
  });

routes.post('/register', [
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
    register(data, function(err, user) {
      if (err != null) {
        res.render('register', {
          data: req.body
        });
      }
      res.redirect('/');
    });

  });

module.exports = routes;