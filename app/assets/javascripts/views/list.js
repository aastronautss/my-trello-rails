App.ListView = Backbone.View.extend({
  tagName: 'li',
  className: 'list',
  template: App.templates.list,
  events: {

  },

  // showNewCardForm: function(e) {
  //   e.preventDefault();
  //   var $e = $(e.target);
  //   $e.hide().prev('.new-card-form').show();
  // }

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo('ul#lists');
    // this.showCards();
  },

  initialize: function() {
    this.listenTo(this.model, 'destroy', this.remove);
    this.listenTo(this.model, 'save', this.render);

    this.$el.attr('data-id', this.model.get('id'));

    // this.$el.droppable({
    //   accept: 'li.card',
    //   hoverClass: 'hovered',
    //   drop: this.moveCard.bind(this)
    // });

    this.render();
  }
});
