
ListTimelineView = Backbone.View.extend({
  initialize: function(){
    this._feed = [];
    this.render();
  },
  events: {
  },
  changeOpacity: function(value) {
    jQuery('#reload_feed').css('opacity', value);
    jQuery('#tweets').css('opacity', value);
  },
  loadTweets: function(event) {
    var view_ref = this;

    this._feed = new Feed();

    this._feed.fetch({
      data: { id: event },
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

    this.changeOpacity('1.0');
  },
  render: function() {
    var feed_container = this.$el.find("#tweets");
    feed_container.empty();
    _(this._tweetViews).each(function(view) {
      feed_container.append(view.render().el);
    }, this);
  }
});
