App.NotificationView = Backbone.View.extend({
  tagName: 'div',
  className: 'alert',

  template: App.templates.notification,
  wrapper_selector: '#alerts',

  defaults: {
    text: 'Success!',
    alert_type: 'success',
    duration: 6000
  },

  close: function() {
    this.$el.fadeOut('slow', this.remove.bind(this));
  },

  render: function() {
    this.$el.addClass('alert-' + this.options.alert_type);
    this.$el.html(this.template(this.options));
    $(this.wrapper_selector).prepend(this.$el.hide());
    this.$el.fadeIn('slow');
    setTimeout(this.close.bind(this), this.options.duration)
  },

  initialize: function() {
    this.options = _(this.defaults).extend(this.model);
    this.render();
  }
});
