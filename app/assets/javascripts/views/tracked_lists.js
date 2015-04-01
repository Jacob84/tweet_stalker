TrackedLists = Backbone.View.extend({
  el: '#sub_header',
  initialize: function() {
    var self = this;

    this.template = _.template($('#tracked_lists_template').html());

    App.EventsHub.on(AppEvents.TRACKED_LISTS_FETCHED, function() {
      self.load_lists();
    });
  },
  events: {
    'click #add_new_tracked_list' : 'add_tracked_list',
    "change #tracked_lists_dropdown" : 'new_list_selected',
    "click #download_feed": "reloadFeed",
    "click .tracked_list_link": 'new_list_selected'
  },
  reloadFeed: function(event) {
    $.post("/list_update/", { id: App.CurrentListId() }, function( data ) {
      App.SetCurrentListRoute();
    });
  },
  add_tracked_list: function() {
    App.Router.navigate('add_tracked_list', {trigger: true});
  },
  new_list_selected: function(e) {
    var list_id = $(e.currentTarget).data("id");
    App.SetCurrentList(parseInt(list_id));
    App.Router.navigate('load_list_timeline/' + list_id, {trigger: true});
  },
  register_menu: function() {
    $('.sliding-panel-button,.sliding-panel-fade-screen,.sliding-panel-close').on('click touchstart',function (e) {
      $('.sliding-panel-content,.sliding-panel-fade-screen').toggleClass('is-visible');
      e.preventDefault();
    });
  },
  load_lists: function() {
    this.model = App.TrackedLists;
    this.render();
  },
  render: function() {
    $(this.el).html("");
    $(this.el).html(this.template({model: this.model.models, selected: App.CurrentList }));
  }
});
