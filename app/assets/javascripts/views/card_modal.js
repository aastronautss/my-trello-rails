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
    var comment;

    if (body) {
      comment = App.data.comments.create({
        body: body,
        card_id: this.model.get('id')
      }, {
        success: this.showComment.bind(this)
      });
    }
    e.currentTarget.reset();
  },

  showComments: function() {
    var comments = this.model.comments();

    _(comments).each(function(comment) {
      this.showComment(comment);
    }, this);
  },

  showComment: function(comment) {
    var view = new App.CommentView({ model: comment });
    this.$el.find('.comment-list').append(view.el);
  },

  render: function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.showComments();
    this.$el.on('hidden.bs.modal', this.closeModal);
  },

  initialize: function() {
    this.listenTo(this.model, 'change:description', this.render);
    this.listenTo(this.model, 'destroy', this.remove);
    this.render();
  }
});
