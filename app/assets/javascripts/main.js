var App = {
  templates: HandlebarsTemplates,

  fetchCollections: function(board_id) {
    for (var collection in this.data) {
      this.data[collection].fetch({ data: { board_id: board_id } });
    }
  },

  getBoard: function(id) {
    this.current_board = new this.Board({ id: id });
    this.current_board.fetch({
      success: function(model) {
        new App.BoardView({ model: model });
        App.fetchCollections(App.board_id);
      },

      error: function(model, response) {

      }
    });
  },

  initialize: function() {
    this.getBoard(this.board_id);
  }
}

$(function() {
  App.initialize();
});
