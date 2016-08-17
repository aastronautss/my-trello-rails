App.Cards = Backbone.Collection.extend({
  model: App.Card,
  url: '/cards'
});

App.data = App.data || {};
App.data.cards = new App.Cards();
