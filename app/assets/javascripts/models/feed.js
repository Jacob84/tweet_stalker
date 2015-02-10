var Feed = Backbone.Collection.extend({
  model: Tweet,
  url : "/list_timeline"
});
