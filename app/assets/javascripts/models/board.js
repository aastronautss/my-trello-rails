App.Board = Backbone.Model.extend({
  idAttribute: 'id',
  urlRoot: '/boards',
  defaults: {
    title: ''
  },
});
