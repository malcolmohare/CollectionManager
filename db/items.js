// items.js

var AWS = require('aws-sdk');

AWS.config.loadFromPath('./config/config.json');
AWS.config.loger = console;

var docClient = new AWS.DynamoDB.DocumentClient();

const itemsTable = "cmItems";

exports.createItem = function(params, cb) {
  var params = {
    TableName : itemsTable,
    Item : {
      "item-id" : params.itemId,
      "item-name" : params.itemName
    }
  };
  docClient.put(params, cb);
};

exports.getItemById = function(id, db) {
  var params = {
    TableName : itemsTable,
    Key : {
      "item-id" : id
    }
  };
  docClient.get(params, function(err, data) {
    if (data != null) {
      cb(null, data.Item);
    } else {
      cb(new Error("Error fetching item with id " + id + ": " + err));
    }
  });
};
