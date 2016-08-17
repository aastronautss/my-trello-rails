App.ListView = Backbone.View.extend({
  tagName: 'li',
  className: 'list',
  template: App.templates.list,
  events: {
    'click .new-card': 'showNewCardForm',
    'click .cancel-new-card': 'hideNewCardForm',
    'click .delete': 'delete',
    'submit .new-card-form form': 'createCard'
  },

  delete: function(e) {
    e.preventDefault();
    var self = this;

    self.model.destroy({ success: self.clearCards.bind(self) });
  },

  createCard: function(e) {
    e.preventDefault();
    var $e = $(e.target);
    var title = $e.find('[name=title]').val();
    var new_card;

    if (title) {
      new_card = App.data.cards.create({
        title: title,
        list_id: this.model.get('id')
      }, {
        success: this.showCard.bind(this)
      });
    }

    this.hideNewCardForm();
  },

  showNewCardForm: function(e) {
    e.preventDefault();
    var $e = $(e.target);
    $e.hide().prev('.new-card-form').show();
  },

  hideNewCardForm: function(e) {
    if (e) { e.preventDefault() };
    this.$el.find('.new-card-form').hide().next('.new-card').show();
  },

  clearCards: function() {
    var cards = this.model.cards();
    _(cards).invoke('delete');
  },

  showCards: function() {
    var cards = this.model.cards();
    this.$el.find('.cards').html('');

    _(cards).each(this.showCard, this);
  },

  showCard: function(card) {
    var view = new App.CardView({ model: card });
    this.$el.find('.cards').append(view.$el);
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