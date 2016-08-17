var App = {
  templates: HandlebarsTemplates,

  fetchCollections: function(board_id) {
    for (var collection in this.data) {
      this.data[collection].fetch({ data: $.param({ board_id: board_id }) });
    }
  },

  showBoard: function(id) {
    this.current_board = new this.Board({ id: id });
    this.current_board.fetch({
      success: function(model) {
        new App.BoardView({ model: model });
      },

      error: function(model, response) {

      }
    });
  },

  initialize: function() {
    this.showBoard(1);
    this.fetchCollections(1);
  }
}

$(function() {
  App.initialize();
});
