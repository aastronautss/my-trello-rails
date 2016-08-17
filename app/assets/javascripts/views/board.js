App.BoardView = Backbone.View.extend({
  el: '#board',
  template: App.templates.board,
  events: {
    'submit #new-list-form': 'createList'
  },

  createList: function(e) {
    e.preventDefault();
    var title = $(e.target).find('[name="title"]').val();

    App.data.lists.create({
      title: title,
      board_id: App.board_id
    }, {
      success: this.showList
    });

    // this.hideNewListForm();
  },

  showLists: function() {
    var lists = App.data.lists;
    var $lists = $('ul#lists');

    $lists.html('');

    lists.each(this.showList, this);
  },

  showList: function(model) {
    var view = new App.ListView({ model: model });
    $('ul#lists').append(view.$el);
  },

  toJSON: function() { return { list: _.clone(this.attributes) }; },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
  },

  initialize: function() {
    this.listenTo(App.data.lists, 'sync', this.showLists);

    this.render();
  }
});
