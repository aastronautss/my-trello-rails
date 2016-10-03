App.CardModalView = Backbone.View.extend({
  tagName: 'div',
  className: 'modal fade clearfix',
  id: 'card-modal',
  attributes: {
    'tabindex': '-1'
  },

  template: App.templates.card_modal,
  events: {
    // Updating card
    'click .edit-description-link': 'showDescriptionEdit',
    'click .cancel-edit': 'hideDescriptionEdit',
    'submit .edit-description': 'updateDescription',

    // Deleting card
    'click .delete-card': 'deleteCard',

    // Comments
    'submit .new-comment': 'addComment',

    // Checklists
    'click .add-check-item a': 'showNewCheckItemForm',
    'click .cancel-new-check-item': 'hideNewCheckItemForm',
    'submit .new-check-item-form form': 'addCheckItem',
    'click .toggle-check-item': 'toggleCheckItem'
  },

  deleteCard: function(e) {
    e.preventDefault();
    this.model.destroy();
  },

  closeModal: function() {
    this.remove();
  },

  showDescriptionEdit: function(e) {
    e.preventDefault();
    var $e = $(e.target);
    var $form = this.$el.find('.edit-description');
    var $descrip = $e.next('.description');
    $form.find('textarea').val(this.model.get('description'));

    $descrip.hide();
    $e.hide();
    $form.show();
  },

  hideDescriptionEdit: function(e) {
    if (e) { e.preventDefault(); }
    var $form = this.$el.find('.edit-description');
    var $edit_link = this.$el.find('.edit-description-link');
    var $descrip = this.$el.find('.description');

    $form.hide();
    $descrip.show();
    $edit_link.show();
  },

  updateDescription: function(e) {
    e.preventDefault();
    var $form = $(e.currentTarget);
    var description = $form.find('textarea').val();

    this.model.save({ description: description });
    this.hideDescriptionEdit();
  },

  addComment: function(e) {
    e.preventDefault();
    var body = $(e.currentTarget).find('[name=comment-body]').val();
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    if (body) {
      $.ajax({
        context: this,
        method: 'POST',
        url: '/cards/' + this.model.get('id') + '/add_comment',
        headers: {
          'X-CSRF-Token': csrf_token
        },
        data: { comment: { body: body } }
      }).done(function(msg) {
        this.model.fetch();
      });
    }

    e.currentTarget.reset();
  },

  showNewCheckItemForm: function(e) {
    e.preventDefault();
    var $target = $(e.target).closest('.add-check-item');
    var $form = $target.next('.new-check-item-form');

    $target.hide();
    $form.show();
    $form.find('[name="name"]').focus();
  },

  hideNewCheckItemForm: function(e) {
    e.preventDefault();
    var $form = $(e.target).closest('.new-check-item-form');
    var $add_item_button = $form.prev('.add-check-item');

    $form.hide();
    $add_item_button.show();
  },

  addCheckItem: function(e) {
    e.preventDefault();
    var $target = $(e.currentTarget);
    var name = $target.find('[name="name"]').val();
    var csrf_token = $('meta[name="csrf-token"]').attr('content');
    var checklist_id = $target.closest('.checklist').data('id');

    if (name) {
      $.ajax({
        context: this,
        method: 'POST',
        url: '/cards/' + this.model.get('id') + '/checklists/' + checklist_id + '/check_items',
        headers: {
          'X-CSRF-Token': csrf_token
        },
        data: { 'check_item': { name: name } }
      }).done(function(msg) {
        this.model.fetch();
      });
    }

    e.currentTarget.reset();
  },

  toggleCheckItem: function(e) {
    e.preventDefault();
    var $target = $(e.currentTarget);
    var card_id = this.model.get('id');
    var checklist_id = $target.closest('.checklist').data('id');
    var check_item_id = $target.closest('.check-item').data('id');
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      context: this,
      method: 'GET',
      url: '/cards/' + card_id + '/checklists/' + checklist_id + '/check_items/' + check_item_id + '/toggle',
      headers: {
        'X-CSRF-Token': csrf_token
      }
    }).done(function(msg) {
      this.model.fetch();
    });
  },

  sortedActivities: function() {
    var activities = this.model.get('activities');

    return _(activities).sortBy(function(activity) {
      new Date(activity.timestamp);
    });
  },

  showActivities: function() {
    var activities = this.sortedActivities();

    _(activities).each(function(activity) {
      this.showActivity(activity);
    }, this);
  },

  showActivity: function(activity) {
    var type = activity.type
    var view = new App[App.capitalize(type) + 'View']({ model: activity });
    this.$el.find('.comment-list').prepend(view.el);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.showActivities();
    this.$el.on('hidden.bs.modal', this.closeModal);
  },

  initialize: function() {
    this.listenTo(this.model, 'sync', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
    this.render();
  }
});
