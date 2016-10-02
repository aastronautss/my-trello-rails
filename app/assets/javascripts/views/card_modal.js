App.CardModalView = Backbone.View.extend({
  tagName: 'div',
  className: 'modal fade clearfix',
  id: 'card-modal',
  attributes: {
    'tabindex': '-1'
  },

  template: App.templates.card_modal,
  events: {
    'click .edit-description-link': 'showDescriptionEdit',
    'click .cancel-edit': 'hideDescriptionEdit',
    'click .delete-card': 'deleteCard',
    'submit .edit-description': 'updateDescription',
    'submit .new-comment': 'addComment'
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

    if (body) {
      var csrf_token = $('meta[name="csrf-token"]').attr('content');

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
