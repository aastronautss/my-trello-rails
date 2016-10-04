App.Card = Backbone.Model.extend({
  idAttribute: 'id',
  defaults: {
    description: ''
  },

  comments: function() {
    var activities = this.get('activities');
    return _(activities).where({ type: 'comment' })
  },

  todos: function() {
    var checklists = this.get('checklists');
    var all_todos = [];

    _(checklists).each(function(checklist) {
      all_todos = all_todos.concat(checklist.check_items);
    });

    return all_todos;
  },

  doneTodos: function() {
    var todos = this.todos();

    return _(todos).where({ done: true });
  },

  viewAttrs: function() {
    return {
      title: this.get('title'),
      description: this.get('description'),
      num_comments: this.comments().length,
      done_todos: this.doneTodos().length,
      todos: this.todos()
    }
  }
});
