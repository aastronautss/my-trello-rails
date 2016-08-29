App.CardView = Backbone.View.extend({
  tagName: 'li',
  className: 'card',
  template: App.templates.card,
  events: {
    'click': 'showModal',
  },

  showModal: function(e) {
    e.preventDefault();

    if (this.$el.hasClass('noclick')) {
      this.$el.removeClass('noclick');
    }
    else {
      var modal_view = new App.CardModalView({ model: this.model });
      modal_view.$el.appendTo('body');
    }
  },

  clearComments: function() {
    var comments = this.model.comments();
    _(comments).invoke('delete');
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  },

  initialize: function() {
    this.listenTo(this.model, 'save', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
    this.listenTo(this.model, 'delete', this.remove);

    this.$el.attr('data-id', this.model.get('id'));

    // this.$el.draggable({
    //   stack: 'body',
    //   revert: true,
    //   start: function(event, ui) {
    //     $(this).addClass('noclick');
    //   }
    // });

    this.render();
  }
});
