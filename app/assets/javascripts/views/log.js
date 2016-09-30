App.LogView = Backbone.View.extend({
  tagName: 'li',
  className: 'log',
  template: App.templates.comment,

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  },

  initialize: function() {
    this.render();
  }
});
