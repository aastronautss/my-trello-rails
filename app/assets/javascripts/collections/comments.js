App.Comments = Backbone.Collection.extend({
  model: App.Comment,
  url: '/comments'
});

App.data = App.data || {};
App.data.comments = new App.Comments();
