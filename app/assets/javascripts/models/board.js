App.Board = Backbone.Model.extend({
  idAttribute: 'id',
  urlRoot: '/boards',
  defaults: {
    title: ''
  },

  // getLists: function() {
  //   return _(App.data.lists).select(function(list) {
  //     return list.get('board_id') === this.get('id');
  //   });
  // }
});
