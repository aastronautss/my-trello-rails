App.Lists = Backbone.Collection.extend({
  model: App.List,
  url: '/lists',
  comparator: 'position'
});

App.data = App.data || {};
App.data.lists = new App.Lists();
