$(function() {
  $('#subscribe-form').submit(function(e) {
    e.preventDefault();
    var $form = $(this);
    $form.find('.payment-submit').prop('disabled', true);

    Stripe.card.createToken({
      number: $('.card-number').val(),
      cvc: $('.card-cvc').val(),
      exp_month: $('.card-expiry-month').val(),
      exp_year: $('.card-expiry-year').val()
    }, stripeResponseHandler);
    return false;
  });

  var stripeResponseHandler = function(status, response) {
    var $form = $('#subscribe-form');

    if (response.error) {
      $form.find('.payment-errors').text(response.error.message);
      $form.find('.payment-submit').prop('disabled', false);
    }
    else {
      var token = response.id;
      $form.append($('<input type="hidden" name="stripeToken" />').val(token));
      $form.get(0).submit();
    }
  }
});
