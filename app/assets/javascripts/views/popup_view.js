
PopupView = Backbone.View.extend({
  el: '#main_container',

  initialize: function() {
    this.base_template = $('#popup_template').html();
    this.context = { title: 'Some title' };
  },
  events: {

  },
  render: function() {
    $(this.el).append(_.template(this.base_template, this.context));
    this.contents_el = $(this.el).find('.popup_contents');
  },
  render_content: function(content) {
    if (content)
      this.contents_el.html(content);
  }
});

TrackedListsPopupView = PopupView.extend({
  initialize: function () {
    TrackedListsPopupView.__super__.initialize.call(this);

    this._models = [];
    this.template = _.template($('#tracked_lists_template').html());
    this.context = { title: 'Child Title' };
    this.render();
  },
  load_lists: function () {
    var self = this;

    this._lists = new Lists;
    this._lists.fetch({
      success: function(collection){
        self._models = collection.models;
        self.render_content();
      }
    });
  },
  render_content: function() {
    var self = this;
    _(this._models).each(function(model) {
      self.contents_el.append(self.template({model: model}));
    });
  }
});
