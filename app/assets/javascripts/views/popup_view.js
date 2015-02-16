
PopupView = Backbone.View.extend({
  el: '#popup',

  initialize: function() {
    this.template = $('#popup_template').html();

    this.context = {
      title: 'Some title',
      content: ''
    }

    this.render();
  },
  events: {

  },
  render: function() {
    $(this.el).html(_.template(this.template, this.context));
  }
})
