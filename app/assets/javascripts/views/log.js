App.LogView = Backbone.View.extend({
  tagName: 'li',
  className: 'comment log',
  template: App.templates.log,

  render: function() {
    this.$el.html(this.template(this.model));
    return this;
  },

  initialize: function() {
    this.render();
  }
});
