$(document).ready(function() {
  $('#recoveryForm').validate({
    rules:
      {
        email: {
          required: true,
          email: true,
        },
      },
    submitHandler: sendRecoveryRequest,
  });

  /**
   * Ajax call that creates a recovery request
   * @param form
   */
  function sendRecoveryRequest(form) {
    let email = $('#email').val();

    let request = $.ajax({
      type: 'GET',
      url: BASE_URL + 'api/authentication/recovery.php',
      data: {
        'email': email
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        $(form).trigger('reset');
      }
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + response + '</div>',
          type: 'inline',
        },
      });
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  }
});
