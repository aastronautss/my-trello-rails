Handlebars.registerHelper('numComments', function(card) {
  return _(card.activities).where({ type: 'comment' });
});

Handlebars.registerHelper('exists', function(variable, options) {
  if (typeof variable !== 'undefined') {
    return options.fn(this);
  } else {
    return options.inverse(this);
  }
});
