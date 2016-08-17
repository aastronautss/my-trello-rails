App.List = Backbone.Model.extend({
  idAttribute: 'id',
  defaults: {
    title: ''
  },

  removeFromBoard: function() {
    var boardID = App.current_board;
    var board = App.data.boards.get(boardID);
    var boardLists = board.get('lists');

    board.save({ lists: _(boardLists).without(this.id) });
  },

  clearCards: function() {
    var cardIDs = this.get('cards');
    _(cardIDs).each(function(id) {
      var card = App.data.cards.get(id);
      card.clear();
      card.destroy();
    });
  },

  getCard: function(id) {
    if (_(this.get('cards')).includes(id)) {
      return App.data.cards.get(id);
    }
    return undefined;
  }
});
