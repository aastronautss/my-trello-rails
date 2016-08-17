App.BoardView = Backbone.View.extend({
  el: '#board',
  template: App.templates.board,
  events: {

  },

  // showLists: function() {
  //   var lists = App.data.lists;

  //   lists.each(function(list) {
  //     new App.ListView({ model: list });
  //   });
  // },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    // this.showLists();
  },

  initialize: function() {
    this.render();
  }
});
