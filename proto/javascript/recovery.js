$(document).ready(function() {
  $('button[type=submit]').click(function() {
    let email = $('#email').val();

    let request = $.ajax({
      type: 'GET',
      url: BASE_URL + 'api/authentication/recovery.php',
      data: {
        'email': email,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        console.info(response);
        $('form').remove();
        $('.container').prepend('<p>We sent an email to <strong>' + email + '</strong></p>');
      } else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + response + '</div>',
            type: 'inline',
          },
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  });
});
