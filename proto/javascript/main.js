BASE_URL = '/';

$(document).ready(function() {
  let token = $('input[name=token]').val();
  let userId = $('input[name=user_id]').val();
  let adminId = $('input[name=admin_id]').val();

  $('#signInForm').validate({
    rules:
      {
        username: {
          required: true,
          maxlength: 32,
        },
        password: {
          required: true,
          minlength: 8,
          maxlength: 32,
        },
      },
    messages:
      {
        username: {
          required: 'Please, enter your username.',
          maxlength: 'Your username ' +
          'must be no more than 32 characters.',
        },
        password: {
          required: 'Please, enter your password.',
          minlength: 'Your password should ' +
          'be between 8 and 32 characters.',
          maxlength: 'Your password should ' +
          'be between 8 and 32 characters.',
        },
      },
    errorPlacement: function(error, element) {
      error.insertAfter(element);
    },
    submitHandler: signIn,
  });

  /**
   * Call an ajax request responsible to sign in an user
   */
  function signIn() {
    let form = $('#signInForm');
    let username = form.find('#usrname').val();
    let password = form.find('#psw').val();
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/authentication/signin.php',
      data: {
        'username': username,
        'password': password,
      },
      datatype: 'text',
    });

    // Callback handler that will be called on success
    request.done(function(response, textStatus, jqXHR) {
      if(response === 'Login Successful!') {
        window.location.href=window.location.href;
      }else {
        $('#loginModal').find('.field_error').text(response);
      }
    });

    // Callback handler that will be called on failure
    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  }

  $('.leaveFeedbackPopup').on('click', function() {
    $('.leaveFeedbackPopup').magnificPopup({
      type: 'inline',
      midClick: true,
    }).magnificPopup('open');
  });

  $('#feedbackForm').validate({
    rules: {
      notification: {
        required: true,
        maxlength: 256,
      },
    },
    submitHandler: leaveFeedback,
  });

  /**
   * Handles an ajax call that leaves feedback from an user
   */
  function leaveFeedback() {
    $.magnificPopup.close();
    let feedbackForm = $('#feedbackForm');
    let username = feedbackForm.find('input[name=username]').val();
    let feedback = feedbackForm.find('textarea#feedback').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/feedback.php',
      data: {
        'username': username,
        'feedback': feedback,
      },
      datatype: 'text',
    });

    // Callback handler that will be called on success
    request.done(function(response, textStatus, jqXHR) {
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + response + '</div>',
          type: 'inline',
        },
      });
      feedbackForm.trigger('reset');
    });

    // Callback handler that will be called on failure
    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  }

  /**
   * Updates the notification bar in the header
   * @param {number} numNotifications
   */
  function updateNotificationBadge(numNotifications) {
    $('.dropdown .badge').html(numNotifications);
  }

  $('.notifications-wrapper .hideNotification').click(function(e) {
    let notificationsWrapper = $('.notifications-wrapper');
    let numNotifications = notificationsWrapper.children().length;
    let notification = $(this).parents('.notifications-wrapper');

    notification.fadeOut(500, function() {
      notification.remove();

      // To avoid setting to zero after 500 mls passed.
      if(numNotifications !== 1)
        updateNotificationBadge(numNotifications-1);
    });

    numNotifications = notificationsWrapper.children().length;

    if(numNotifications === 1) {
      $('<p class="notifications-empty">' +
        'You have no new notifications</p>')
        .insertAfter('.notifications hr.divider:first');
      updateNotificationBadge(0);
    } else
      e.stopPropagation();    // Keeps the notification dropdown open.
  });

  // Remove all notifications.
  $('.notification-footer h4.markRecentNotificationsAsRead')
    .click(function() {
      let notifications = $('.notifications');
      let nrNotifications = notifications.children('.notifications-wrapper').length;

      let notificationsIds = [];
      notifications.children('.notifications-wrapper').each( function() {
        let notificationClass = $(this).find('.notification-media').attr('class').split('id-');
        if (notificationClass.length === 2) {
          let idVar = notificationClass[1];
          notificationsIds.push(idVar);
        }
        this.remove();
      });

      if(nrNotifications > 0) {
        $.ajax({
          type: 'POST',
          url: BASE_URL + 'api/user/read_notification.php',
          data: {
            'notifications': notificationsIds,
            'token': token,
            'userId': userId,
          },
          datatype: 'text',
        });

        $('<p class="notifications-empty">' +
          'You have no new notifications</p>')
          .insertAfter('.notifications hr.divider:first');
      }

      updateNotificationBadge(0);
    });

  // Collapses 'Categories' panel if in mobile.
  if($(window).width() <= 425)
    $('#categories-wrapper').removeClass('in');
});
