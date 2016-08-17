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
};

$(function() {
  Backbone._sync = Backbone.sync;
  Backbone.sync = function(method, model, options) {
    if (!options.noCSRF) {
      var beforeSend = options.beforeSend;

      // Set X-CSRF-Token HTTP header
      options.beforeSend = function(xhr) {
        var token = $('meta[name="csrf-token"]').attr('content');
        if (token) { xhr.setRequestHeader('X-CSRF-Token', token); }
        if (beforeSend) { return beforeSend.apply(this, arguments); }
      };
    }
    return Backbone._sync(method, model, options);
  };

  App.initialize();
});