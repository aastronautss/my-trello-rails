App.BoardView = Backbone.View.extend({
  el: '#board',
  template: App.templates.board,
  events: {
    'submit #new-list-form': 'createList',
    'click .idle': 'showNewListForm',
    'click .cancel-new-list': 'hideNewListForm',
    'click .menu-show': 'showMenu'
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

  showMenu: function(e) {
    e.preventDefault();
    var $menu = $('#menu');
    var $menu_show = $('.menu-show');

    $menu.fadeIn();
    $menu_show.fadeOut();

    $menu.find('.menu-close').on('click', function(e) {
      e.preventDefault();
      $menu.fadeOut();
      $menu_show.fadeIn();
      $menu.find('.menu-close').off('click');
    });
  },

  hideMenu: function(e) {
    e.preventDefault();
    $('#menu').fadeOut();
    $('.menu-show').show();
  },

  createList: function(e) {
    e.preventDefault();
    var $title = $(e.target).find('[name="title"]');
    var title = $title.val();

    App.data.lists.create({
      title: title,
      board_id: App.board_id
    }, {
      success: this.listCreated.bind(this),
      error: function() { App.notify("Something went wrong.", "danger"); }
    });

    $title.val('');
    this.hideNewListForm();
  },

  listCreated: function(model) {
    App.notify('List "' + model.get('title') + '" created!');
    this.showList(model);
  },

  showLists: function() {
    var lists = App.data.lists;
    var $lists = $('ul#lists');

    $lists.html('');

    lists.sort();
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
