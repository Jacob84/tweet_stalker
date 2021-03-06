// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require underscore
//= require backbone

//= require ./models/tweet
//= require ./models/feed

//= require ./views/popup_view
//= require_tree ./views/

//= require_tree .

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var Router = Backbone.Router.extend({
  routes: {
    "": "init",
    "load_list_timeline/:list_id": "load_list_timeline",
    "add_tracked_list": "add_tracked_list"
  },
  render_tracked_lists: function() {
    var tracked_lists = new TrackedLists();
    tracked_lists.load_lists();
    tracked_lists.register_menu();
  },
  init: function() {
    this.render_tracked_lists();
  },
  load_list_timeline: function(list_id) {
    App.TimelineView.loadTweets(list_id);
    this.render_tracked_lists();
  },
  add_tracked_list: function() {
    var popup_view = new AddTrackedListsPopupView({el: '#popup_placeholder'});
    popup_view.load_lists();
    this.render_tracked_lists();
  }
});

var App = {};

var AppEvents = {
  TRACKED_LISTS_FETCHED: 'tracked_lists_fetched'
};

$(function() {
  App.TimelineView = new ListTimelineView({ el: $("#feed") });
  App.Router = new Router();
  App.EventsHub = {};
  App.TrackedLists = new Lists();
  App.CurrentListId = null;
  App.CurrentList = new List();

  App.CurrentListId = function() {
    if (App.CurrentList)
      return App.CurrentList.get('twitter_list_id');
  };

  App.SetCurrentList = function(list_id) {
    for (var i = 0; i < App.TrackedLists.models.length; i++) {
      var current_list_id = App.TrackedLists.models[i].get('twitter_list_id');

      if (current_list_id === list_id) {
        App.CurrentList = App.TrackedLists.models[i];
        return;
      }
    }

    App.CurrentList = null;
  };

  App.ReloadTrackedLists = function() {
    App.TrackedLists.fetch({
      success: function(collection){
        App.EventsHub.trigger(AppEvents.TRACKED_LISTS_FETCHED);
      }
    });
  };

  App.SetCurrentListRoute = function() {
    if (!App.CurrentListId()) {
      if ((App.TrackedLists.models) && (App.TrackedLists.models.length > 0))
        App.CurrentList = App.TrackedLists.models[0];
    }

    if (App.CurrentListId())
      App.Router.navigate('load_list_timeline/' + App.CurrentListId(), {trigger: true});
    else
      App.Router.navigate('', {trigger: true});
  };

  App.TrackedLists.fetch({
    success: function(collection){
      _.extend(App.EventsHub, Backbone.Events);

      Backbone.history.start();

      App.SetCurrentListRoute();
    }
  });
});
