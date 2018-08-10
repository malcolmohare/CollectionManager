// elastic search

// cribbed from https://www.compose.com/articles/getting-started-with-elasticsearch-and-node/

var elasticsearch = require('elasticsearch');

var client = new elasticsearch.Client({
  hosts : [
    'https://localhost:9200'
  ]
});

exports.putItem = function(item, cb) {
  client.index({
    index: 'items',
    id : item.itemId,
    type : 'item',
    body : {
      'item-id' : item.itemId,
      'item-name' : item.itemName
    }
  }, function(err, resp, status) {
    console.log(resp);
    cb(err, resp);
  });
};

exports.searchItem = function(searchString, cb) {
  client.search({ 
    index: 'items',
    type: 'item',
    body: {
      query: {
        match: { "item-name": searchString }
      }
    }
  }, function(err, resp, status) {
    if (err) {
      console.log(err);
      cb(err, null);
    } else {
      console.log("--- Response ---");
      console.log(resp);
      cb(null, resp.hits);
      resp.hits.hits.forEach(function(hit) {
        console.log(hit);
      });
    }
  });
};
