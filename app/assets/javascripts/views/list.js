App.ListView = Backbone.View.extend({
  tagName: 'li',
  className: 'list',
  template: App.templates.list,
  events: {
    'click .delete': 'delete'
  },

  delete: function(e) {
    e.preventDefault();
    var self = this;

    self.model.destroy({ success: self.clearCards.bind(self) });
  },

  // showNewCardForm: function(e) {
  //   e.preventDefault();
  //   var $e = $(e.target);
  //   $e.hide().prev('.new-card-form').show();
  // }

  clearCards: function() {
    var cards = this.model.cards();
    _(cards).invoke('delete');
  },

  showCards: function() {
    var cards = this.model.cards();
    var $cards_el = this.$el.find('.cards');

    $cards_el.html('');

    _(cards).each(function(card) {
      (new App.CardView({ model: card })).$el.appendTo($cards_el);
    });
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.$el.appendTo('ul#lists');
    this.showCards();
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
