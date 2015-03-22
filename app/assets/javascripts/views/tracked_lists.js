TrackedLists = Backbone.View.extend({
  el: '#sub_header',
  initialize: function() {
    this.template = _.template($('#tracked_lists_template').html());
  },
  events: {
    'click #add_new_tracked_list' : 'add_tracked_list',
    "change #tracked_lists_dropdown" : 'new_list_selected'
  },
  add_tracked_list: function() {
    App.Router.navigate('add_tracked_list', {trigger: true});
  },
  new_list_selected: function(ev) {
    var list_id = $(ev.target).find("option:selected").val();
    App.CurrentListId = list_id;
    App.Router.navigate('load_list_timeline/' + list_id, {trigger: true});
  },
  load_lists: function() {
    this.model = App.TrackedLists;
    this.render();
  },
  render: function() {
    $(this.el).html("");
    $(this.el).html(this.template({model: this.model.models}));
  }
});
