$(document).ready(function() {
  $('#resetPasswordForm').validate({
    rules:
      {
        newPassword: {
          required: true,
          minlength: 8,
          maxlength: 64,
        },
        repeatPassword: {
          required: true,
          equalTo: $(this).find('#newPassword'),
        },
      },
    messages:
      {
        newPassword: {
          required: 'Please, enter your password.',
          minlength: 'Your password should be between 8 and 64 characters.',
          maxlength: 'Your password should be between 8 and 64 characters.',
        },
        repeatPassword: {
          required: 'Please, enter confirm your password.',
          equalTo: 'The confirmation password does not match.',
        },
      },
    errorPlacement: function(error, element) {
      $(element).closest('.form-group').append(error);
    },
  });

  /**
   * Ajax call that reset the user password
   */
  $('.btn').click(function() {
    let form = $('#resetPasswordForm');
    let newPass = $('#newPassword').val();
    let newPassRepeat = $('#repeatPassword').val();
    let email = $('#email').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/authentication/reset_password.php',
      data: {
        'newPass': newPass,
        'newPassRepeat': newPassRepeat,
        'email': email,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.indexOf('Success') >= 0) {
        $(form).remove();
        $('.form-wrap').append('<p class="text-center">Password updated with success.</p><a href="' + BASE_URL + '">Back to main page</a>');
      } else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + response + '</div>',
            type: 'inline',
            mainClass: 'mfp-fade',
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
