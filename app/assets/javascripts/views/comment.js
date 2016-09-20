App.CommentView = Backbone.View.extend({
  tagName: 'li',
  className: 'comment',
  template: App.templates.comment,

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  initialize: function() {
    this.render();
  }
});
