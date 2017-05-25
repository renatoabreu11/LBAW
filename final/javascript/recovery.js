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
        'email': email,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        $(form).trigger('reset');
      }
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + message + '</div>',
          type: 'inline',
          mainClass: 'mfp-fade',
        },
      });
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  }
});
