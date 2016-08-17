App.BoardView = Backbone.View.extend({
  el: '#board',
  template: App.templates.board,
  events: {
    'submit #new-list-form': 'createList',
    'click .idle': 'showNewListForm',
    'click .cancel-new-list': 'hideNewListForm'
  },

  showNewListForm: function(e) {
    e.preventDefault();
    var $e = $(e.currentTarget);

    $e.removeClass('idle');
    $e.find('[type="text"]').focus().select();
  },

  hideNewListForm: function(e) {
    if (e) { e.preventDefault(); }
    $('.new-list').addClass('idle');
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

    this.hideNewListForm();
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

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
  },

  initialize: function() {
    this.listenTo(App.data.lists, 'sync', this.showLists);

    this.render();
  }
});
