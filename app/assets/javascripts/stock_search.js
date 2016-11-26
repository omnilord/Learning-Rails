$(function() {
  var maindiv = $('#main_content'),
      tmpls = {
        spinner: Handlebars.compile($('#handlebars-spinner').html()),
        stock: Handlebars.compile($('#handlebars-stock').html()),
        error: Handlebars.compile($('#handlebars-error').html())
      };

  $('#search-stock-form').on({
    'ajax:success': function (ev, data, status) {
      console.log(ev, data, status);
      maindiv.html(tmpls.stock(data));
    },
    'ajax:before': function() {
      maindiv.html(tmpls.spinner());
    },
    'ajax:after': function() {
      maindiv.html(tmpls.spinner());
    },
    'ajax:error': function (ev, xhr, status, err) {
      console.log(ev, xhr, status, err);
      maindiv.html(tmpls.error({msg: 'No stock found.'}));
    }
  });
});
