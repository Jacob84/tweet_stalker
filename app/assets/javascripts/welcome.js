$(function() {
  var feed_view = new FeedView({ el: $("#feed") });
  feed_view.loadTweets();

  var popup_view = new TrackedListsPopupView();
  popup_view.load_lists();
});
