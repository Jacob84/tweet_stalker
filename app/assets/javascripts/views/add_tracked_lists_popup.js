AddTrackedListsPopupView = PopupView.extend({
  initialize: function () {
    AddTrackedListsPopupView.__super__.initialize.call(this);

    this.template = _.template($('#add_tracked_lists_template').html());
    this.loading_template = _.template($('#ajax_loading_template').html());

    this.context = { title: 'Child Title' };
    this.save_function = this.submit_to_server;

    this.render();
  },
  events: function() {
    return _.extend({},PopupView.prototype.events,{
      'click .tracked_list_checkbox': 'update_collection'
    });
 },
  update_collection: function(evt) {
    id = $(evt.currentTarget).val();

    var result = this.model.find(function(model) {
      var numericIdentifier = parseInt(id);
      return model.get('twitter_list_id') === numericIdentifier; }
    );

    result.set({'tracked': 'true'});
  },
  submit_to_server: function() {
    var self = this;
    Backbone.sync('create', this.model, {
      success: function(collection){
        self.close();
      }});
  },
  load_lists: function () {
    var self = this;

    this._lists = new Lists();

    this._lists.fetch({
      data: { show_all: true },
      success: function(collection){
        self.model = collection;
        self.render_content();
      }
    });
  },
  render_content: function() {
    var self = this;
    self.contents_el.html("");

    if (!this.model) {
      self.contents_el.append(self.loading_template());
    }
    else {
      _(this.model.models).each(function(model) {
        self.contents_el.append(self.template({model: model}));
      });
    }
  }
});
