
FeedView = Backbone.View.extend({
  initialize: function(){
    this._feed = [];
    this.render();
  },
  events: {
      "click #load_button": "loadTweets"
  },
  loadTweets: function(event) {
    var view_ref = this;
    this._feed = new Feed;

    this._feed.fetch({
      success: function(collection){
        view_ref._tweetViews = [];

        _(collection.models).each(function(model) {
          view_ref._tweetViews.push(new TweetView({
            model : model,
          }));
        });

        view_ref.render();
      }
    });
  },
  render: function() {
    var that = this;

    $(this.el).empty();

    _(this._tweetViews).each(function(view) {
      $(that.el).append(view.render().el);
    }, this);
  }
});
