$(document).on('turbolinks:load', (function () {
  function show_error(message) {
    var $fm = ($('#flash-messages').size() < 1)
            ? $('div.container').prepend('<div id="flash-messages"></div>')
            : $('#flash-messages');
    $fm.html(
      '<div class="alert alert-warning">'
      + '<a class="close" data-dismiss="alert">×</a>'
      + '<div id="flash_alert">' + message + '</div>'
    + '</div>');
    $fm.find('.alert').delay(5000).fadeOut(3000);

    return false;
  };

  return function () {
    var $form = $('.cc_form').off('submit').on('submit', function (event) {
          var $target = $(event.target);

          $target.find('input[type="submit"]').prop('disabled', true);
          //If Stripe was initialized correctly this will create a token using the credit card info
          if (Stripe) {
            // ToDo: show a "doing something" overlay
            Stripe.card.createToken($target, function (status, response) {
              if (response.error) {
                console.log(response.error);
                show_error(response.error.message);
                $form.find('input[type="submit"]').prop('disabled', false);
              } else {
                $form.append($('<input type="hidden" name="payment[token]" />').val(response.id));
                $form.find('[data-stripe], .cc-payment-row').remove();
                $form.get(0).submit();
              }

              return false;
            });
          } else {
            show_error('Failed to load credit card processing functionality. Please reload this page in your browser.')
          }

          return false;
        });
  };
})());
