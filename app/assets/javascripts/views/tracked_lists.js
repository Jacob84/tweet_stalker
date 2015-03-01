
TrackedLists = Backbone.View.extend({
  el: '#sub_header',
  initialize: function() {
    this.template = _.template($('#tracked_lists_template').html());
  },
  events: {
    'click #add_new_tracked_list' : 'add_tracked_list'
  },
  add_tracked_list: function() {
    App.EventsHub.trigger("newTrackedList");
  },
  load_lists: function() {
    var self = this;

    this._lists = new Lists;

    this._lists.fetch({
      success: function(collection){
        self.model = collection;
        self.render();
      }
    });
  },
  render: function() {
    $(this.el).html("");
    $(this.el).html(this.template({model: this.model.models}));
  }
});
