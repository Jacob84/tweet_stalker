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
    "add_tracked_list": "add_tracked_list"
  },
  init: function() {
    var tracked_lists = new TrackedLists();
    tracked_lists.load_lists();
  },
  add_tracked_list: function() {
    var popup_view = new AddTrackedListsPopupView();
    popup_view.load_lists();
  }
});

var App = {};

$(function() {
  App.Router = new Router();
  App.EventsHub = {};
  _.extend(App.EventsHub, Backbone.Events);
  Backbone.history.start();
});
