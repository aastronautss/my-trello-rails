App.Card = Backbone.Model.extend({
  idAttribute: 'id',
  defaults: {
    title: '',
    description: ''
  },

  currentList: function() {
    return App.data.lists.find(function(model) {
      return model.id === this.get('list_id');
    }, this);
  }
});
