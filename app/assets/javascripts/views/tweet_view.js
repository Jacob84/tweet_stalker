TweetView = Backbone.View.extend({
  tagName : "div",
  className : "tweet",

  render : function() {
    var template = _.template($("#tweet_template").html());
    this.el.innerHTML = template({model: this.model});
    return this;
  }
});
