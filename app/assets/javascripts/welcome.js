$(function() {
  var feed_view = new FeedView({ el: $("#feed") });
  feed_view.loadTweets();

  var popup_view = new AddTrackedListsPopupView();
  // popup_view.load_lists();

  var tracked_lists = new TrackedLists();
  tracked_lists.load_lists();
});
