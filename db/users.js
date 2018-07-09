var records = [
    { id: 1, username: 'jack', password: 'secret', displayName: 'Jack', emails: [ { value: 'jack@example.com' } ] }
  , { id: 2, username: 'jill', password: 'birthday', displayName: 'Jill', emails: [ { value: 'jill@example.com' } ] }
];

var AWS = require('aws-sdk');

AWS.config.loadFromPath('./config/config.json');
AWS.config.logger = console;

var docClient = new AWS.DynamoDB.DocumentClient();
var table = "cmUsers";
var emailIndex = "cmUsersEmailGsi";


var findById = function(id, cb) {
  process.nextTick(function() {
    var params = {
      TableName : table,
      Key : {
        "id" : id
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
}

exports.findById = findById;
exports.findByUsername = function(username, cb) {
  process.nextTick(function() {
    var params = {
      TableName : table,
      IndexName : emailIndex,
      KeyConditionExpression : "email = :username",
      ExpressionAttributeValues : {
        ":username" : username
      }
    };
    docClient.query(params, function(err, data) {
      if (data != null) {
        findById(data.Items[0].id, cb);
      } else {
        cb(new Error('User' + username + ' does not exist: ' + err));
      }
    });
  });
}

