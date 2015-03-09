$(function() {
  var feed_view = new FeedView({ el: $("#feed") });
  feed_view.loadTweets();
});
