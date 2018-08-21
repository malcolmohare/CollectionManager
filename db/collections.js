// collections.js

var AWS = require('aws-sdk');

AWS.config.loadFromPath('./config/config.json');
AWS.config.logger = console;

var docClient = new AWS.DynamoDB.DocumentClient();

const collectionTable = "cmCollections";
const itemsTable = "cmItems";

exports.createCollection = function(params, cb) {
  var params = {
    TableName : collectionTable,
    Item: {
      "collection-type" : params.collectionType,
      "collection-name" : params.collectionName
    }
  };
  docClient.put(params, function(err, data) {
    cb(err, data);
  });
}; 

exports.getCollections = function(collectionType, cb) {
  var params = {
    TableName : collectionTable,
    KeyConditionExpression : "collection-type = :collection-type",
    ExpressionAttributeValues :  {
      ":collection-type" : collectionType
    }
  };
  docClient.query(params, function(err, data) {
    if (data != null) {
      cb(null, data.Items);
    } else {
      cb(new Error('Error getting collections with type ' + collectionType + ': ' + err));
    }
  });
};

exports.getCollection = function(collectionType, collectionName, cb) {
  var params = {
    TableName : collectionTable,
    Key : {
      "collection-type" : collectionType,
      "collection-name" : collectionName
    }
  };
    docClient.get(params, function(err, data) {
      if (data != null) {
        cb(null, data.Item);
      } else {
        cb(new Error('Error fetching collectionType ' + collectionType + ' collectionName ' + collectionName + ': ' + err));
      }
    });
  };

exports.addItemToCollection = function(collectionType, collectionName, itemId, cb) {
  var params = {
    TableName : collectionTable,
    Key : {
      "collection-type" : collectionType,
      "collection-name" : collectionName
    },
    UpdateExpression : "ADD collectionItems  :itemId",
    ExpressionAttributeValues : { ":itemId" : docClient.createSet([itemId]) } 
  };
  docClient.update(params, function(err, data) {
    if (data != null) {
      cb(null, data);
    } else {
      cb(new Error('Error updating collectionType ' + collectionType + ' collectionName ' + collectionName + ': ' + err));
    }
  });
}

exports.removeItemFromCollection = function(collectionType, collectionName, itemId, cb) {
  var params = {
    TableName : collectionTable,
    Key : {
      "collection-type" : collectionType,
      "collection-name" : collectionName
    },
    UpdateExpression : "DELETE collectionItems  :itemId",
    ExpressionAttributeValues : { ":itemId" : docClient.createSet([itemId]) }
  };
  docClient.update(params, function(err, data) {
    if (data != null) {
      cb(null, data);
    } else {
      cb(new Error('Error updating collectionType ' + collectionType + ' collectionName ' + collectionName + ': ' + err));
    }
  });
}

