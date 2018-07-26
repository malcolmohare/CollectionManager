var AWS = require('aws-sdk');

AWS.config.loadFromPath('./config/config.json');
AWS.config.logger = console;

var docClient = new AWS.DynamoDB.DocumentClient();
var table = "cmUserLogin";
var emailIndex = "cmUsersEmailGsi";


exports.findByUsername = function(username, cb) {
  process.nextTick(function() {
    var params = {
      TableName : table,
      Key : {
        "username" : username
      }
    };
    docClient.get(params, function(err, data) {
      if (data != null) {
        cb(null, data.Item);
      } else {
        cb(new Error('User' + id + ' does not exist'));
      }
    });
  });
};

exports.findByEmail = function(email, cb) {
  process.nextTick(function() {
    var params = {
      TableName : table,
      IndexName : emailIndex,
      KeyConditionExpression : "email = :email",
      ExpressionAttributeValues : {
        ":email" : email
      }
    };
    docClient.query(params, function(err, data) {
      if (data != null) {
        cb(null, data.Items[0]);
      } else {
        cb(new Error('User with email' + email + ' does not exist: ' + err));
      }
    });
  });
};

exports.addUser = function(userdata, cb) {
    var params = {
      TableName : table,
      Item : {
        "username" : userdata.username,
        "email" : userdata.email,
        "password" : userdata.password
      }
    };
    docClient.put(params, function(err, data) {
      cb(err, data);
    });
};

