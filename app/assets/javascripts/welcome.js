$(function() {
  var feed_view = new FeedView({ el: $("#tweet_container") });
  feed_view.loadTweets();
});
