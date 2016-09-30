App.Card = Backbone.Model.extend({
  idAttribute: 'id',
  defaults: {
    title: '',
    description: ''
  }

  // comments: function() {
  //   return App.data.comments.filter(function(comment) {
  //     return comment.get('card_id') == this.get('id');
  //   }, this);
  // }
});
