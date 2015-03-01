
var App = {};
App.EventsHub = {};
_.extend(App.EventsHub, Backbone.Events);


PopupView = Backbone.View.extend({
  el: '#popup_placeholder',

  initialize: function() {
    this.base_template = $('#popup_template').html();
    this.context = { title: 'Some title' };
    this.save_function = null;
  },
  events: {
    'click #popup_save_button': 'save',
    'click .closing_button': 'close'
  },
  close: function() {
    this.remove();
  },
  save: function() {
    if (typeof(this.save_function) == "function") {
      this.save_function();
    }
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

AddTrackedListsPopupView = PopupView.extend({
  initialize: function () {
    AddTrackedListsPopupView.__super__.initialize.call(this);

    var self = this;

    App.EventsHub.on("newTrackedList", function(msg) {
      self.render();
      self.load_lists();
    });

    this.template = _.template($('#add_tracked_lists_template').html());
    this.context = { title: 'Child Title' };
    // this.render();

    this.save_function = this.submit_to_server;

    // this.load_lists();
  },
  events: function(){
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
    Backbone.sync('create', this.model, {
      success: function(collection){

      }});
  },
  load_lists: function () {
    var self = this;

    this._lists = new Lists;

    this._lists.fetch({
      success: function(collection){
        self.model = collection;
        self.render_content();
      }
    });
  },
  render_content: function() {
    var self = this;
    self.contents_el.html("");
    _(this.model.models).each(function(model) {
      self.contents_el.append(self.template({model: model}));
    });
  }
});
