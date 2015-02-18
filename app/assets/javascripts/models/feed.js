var Feed = Backbone.Collection.extend({
  model: Tweet,
  url : "/list_timeline"
});

var Lists = Backbone.Collection.extend({
  model: List,
  url: "/tracked_lists"
});
