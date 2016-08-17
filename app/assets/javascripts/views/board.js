App.BoardView = Backbone.View.extend({
  el: '#board',
  template: App.templates.board,
  events: {

  },

  // addList: function(e) {
  //   e.preventDefault();
  //   var title = $(e.currentTarget).find('[name="title"]').val();
  //   var new_list = App.data.lists.create({ title: title });

  //   this.model.save({ lists: this.model.get('lists').concat([new_list.id]) });
  //   new App.ListView({ model: new_list });
  //   this.hideNewListForm();
  // },

  showLists: function() {
    var lists = App.data.lists;
    var $lists = $('ul#lists');

    $lists.html('');
    console.log(App.data.lists.toJSON());

    lists.each(function(list) {
      var view = new App.ListView({ model: list });
      $lists.append(view.$el);
    });
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
  },

  initialize: function() {
    this.listenTo(App.data.lists, 'sync', this.showLists);

    this.render();
  }
});
