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
    'submit .add-checklist': 'addChecklist',
    'click .add-check-item a': 'showNewCheckItemForm',
    'click .cancel-new-check-item': 'hideNewCheckItemForm',
    'submit .new-check-item-form form': 'addCheckItem',
    'click .toggle-check-item': 'toggleCheckItem',
    'click .delete-check-item': 'deleteCheckItem',

    // Watching
    'click .watch-card': 'watch',
    'click .unwatch-card': 'unwatch',

    // Services
    'click .tweet-card': 'tweet'
  },

  // ====------------------------------====
  // Modal Display Actions
  // ====------------------------------====

  closeModal: function() {
    this.$el.modal('hide');
  },

  // ====------------------------------====
  // Card Actions
  // ====------------------------------====

  deleteCard: function(e) {
    e.preventDefault();
    this.model.destroy({
      success: function() { App.notify('Card deleted!'); },
      error: function() { App.notify('Something went wrong.', 'danger'); }
    });
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

  // ====------------------------------====
  // Comments
  // ====------------------------------====

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
      }).fail(function(msg) {
        App.notify('Something went wrong.', 'danger');
      });
    }

    e.currentTarget.reset();
  },

  // ====------------------------------====
  // Checklists
  // ====------------------------------====

  addChecklist: function(e) {
    e.preventDefault();
    var $target = $(e.currentTarget);
    var card_id = this.model.get('id');
    var title = $target.find('[name="title"]').val();
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    if (title) {
      $.ajax({
        context: this,
        method: 'POST',
        url: '/cards/' + card_id + '/checklists',
        headers: {
          'X-CSRF-Token': csrf_token
        },
        data: { 'checklist': { title: title } }
      }).done(function(msg) {
        this.model.fetch();
      }).fail(function(msg) {
        App.notify('Something went wrong.', 'danger');
      });
    }

    e.currentTarget.reset();
  },

  // ====------------------------------====
  // Check Items
  // ====------------------------------====

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
      }).fail(function(msg) {
        App.notify('Something went wrong.', 'danger');
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
    }).fail(function(msg) {
      App.notify('Something went wrong.', 'danger');
    });
  },

  deleteCheckItem: function(e) {
    e.preventDefault();
    var $target = $(e.currentTarget);
    var card_id = this.model.get('id');
    var checklist_id = $target.closest('.checklist').data('id');
    var check_item_id = $target.closest('.check-item').data('id');
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      context: this,
      method: 'DELETE',
      url: '/cards/' + card_id + '/checklists/' + checklist_id + '/check_items/' + check_item_id,
      headers: {
        'X-CSRF-Token': csrf_token
      }
    }).done(function(msg) {
      this.model.fetch();
    }).fail(function(msg) {
      App.notify('Something went wrong.', 'danger');
    });
  },

  // ====------------------------------====
  // Activities
  // ====------------------------------====

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

  // ====------------------------------====
  // Watching
  // ====------------------------------====

  watch: function(e) {
    e.preventDefault();

    var card_id = this.model.get('id');
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      context: this,
      method: 'POST',
      url: '/cards/' + card_id + '/watch',
      headers: {
        'X-CSRF-Token': csrf_token
      }
    }).done(function(msg) {
      this.model.fetch();
    }).fail(function(msg) {
      App.notify('Something went wrong.', 'danger');
    });
  },

  unwatch: function(e) {
    e.preventDefault();

    var card_id = this.model.get('id');
    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      context: this,
      method: 'DELETE',
      url: '/cards/' + card_id + '/unwatch',
      headers: {
        'X-CSRF-Token': csrf_token
      }
    }).done(function(msg) {
      this.model.fetch();
    }).fail(function(msg) {
      App.notify('Something went wrong.', 'danger');
    });
  },

  // ====------------------------------====
  // Services
  // ====------------------------------====

  tweet: function(e) {
    e.preventDefault();

    var payload = {
      tweet: {
        status: this.formatTweet()
      }
    };

    var csrf_token = $('meta[name="csrf-token"]').attr('content');

    $.ajax({
      context: this,
      method: 'POST',
      url: '/tweets',
      headers: {
        'X-CSRF-Token': csrf_token
      },
      data: payload
    }).done(function(msg) {
      App.notify('Tweet sent!', 'success');
    }).fail(function(msg) {
      var error_message = 'Something went wrong: ' + msg.responseJSON.message
      App.notify(error_message, 'danger');
    });
  },

  formatTweet: function() {
    var card = this.model;
    var text;

    if (card.get('description')) {
      text = card.get('title') + ': ' + card.get('description');
    }
    else {
      text = card.get('title');
    }

    return text.substring(0, 140);
  },

  // ====------------------------------====
  // Core Functions
  // ====------------------------------====

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.showActivities();
    this.$el.on('hidden.bs.modal', this.remove.bind(this));
  },

  initialize: function() {
    this.listenTo(this.model, 'sync', this.render);
    this.listenTo(this.model, 'destroy', this.closeModal);
    this.render();
  }
});
