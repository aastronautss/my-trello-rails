App.List = Backbone.Model.extend({
  idAttribute: 'id',
  defaults: {
    title: ''
  },

  cards: function() {
    var unordered = App.data.cards.select(function(card) {
      return card.get('list_id') == this.get('id');
    }, this);

    return _(unordered).sortBy(function(card) {
      return card.get('position');
    });
  }
});
