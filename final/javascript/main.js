BASE_URL = '/~lbaw1662/final/';
let userId = null;
let token = null;
let adminId = null;

$(document).ready(function() {
  token = $('input[name=token]').val();
  userId = $('input[name=user_id]').val();
  adminId = $('input[name=admin_id]').val();

  $('body').tooltip({
    selector: '[data-toggle=tooltip]',
  });

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
      dataType: 'json',
    });

    // Callback handler that will be called on success
    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        window.location.href=window.location.href;
      }else {
        $('#loginModal').find('.field_error').text(message);
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
      mainClass: 'mfp-fade',
    }).magnificPopup('open');
  });

  $('#feedbackForm').validate({
    rules: {
      feedback: {
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
    let feedback = feedbackForm.find('textarea#feedback').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/feedback.php',
      data: {
        'feedback': feedback,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    // Callback handler that will be called on success
    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + message + '</div>',
          type: 'inline',
          mainClass: 'mfp-fade',
        },
      });
      if(response.includes('Success'))
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
    let notificationsWrapper = $('.dropdown-menu.notifications .notifications-wrapper');
    let numNotifications = notificationsWrapper.children().length;
    let notification = $(this).closest('.notifications-wrapper');

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
  $('#navbar-collapse-1').on('click', '.notification-footer h4.markRecentNotificationsAsRead', function() {
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
      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/read_notifications.php',
        data: {
          'notifications': notificationsIds,
          'token': token,
          'userId': userId,
        },
        dataType: 'json',

      });

      // Callback handler that will be called on success
      request.done(function(data, textStatus, jqXHR) {
        let message = data['message'];
        let response = data['response'];

        if (response.includes('Success')) {
          let nrNotifications = data['nrNotifications'];
          $('.dropdown-menu.notifications').empty();
          $('.dropdown-menu.notifications').append(data['notificationsDiv']);
          updateNotificationBadge(nrNotifications);
        } else {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + message + '</div>',
              type: 'inline',
              mainClass: 'mfp-fade',
            },
          });
        }
      });
    }else updateNotificationBadge(0);
  });

  // Collapses 'Categories' panel if in mobile.
  if($(window).width() <= 425)
    $('#categories-wrapper').removeClass('in');

  setRankings();

  $('#sendContactEmailForm').validate({
    errorElement: 'div',
    rules:
      {
        user_name: {
          required: true,
          maxlength: 32,
        },
        user_email: {
          required: true,
          email: true,
        },
        user_message: {
          required: true,
          maxlength: 1024,
        },
      },
    errorPlacement: function(error, element) {
      error.insertAfter(element);
    },
    submitHandler: contactUs,
  });

  /**
   *
   * @param form
   */
  function contactUs(form) {
    let contactName = $(form).find('#user_name').val();
    let contactEmail = $(form).find('#user_email').val();
    let message = $(form).find('#user_message').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/contact_us.php',
      data: {
        'contactEmail': contactEmail,
        'message': message,
        'contactName': contactName,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let response = data['response'];
      let message = data['message'];

      if(response.includes('Success 200')) {
        $('#contact-us-modal').modal('hide');
        $(form).trigger('reset');
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
            type: 'inline',
            mainClass: 'mfp-fade',
          },
        });
      } else {
        $(form).find('.field_error').text(message);
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  }
});

/**
 * For each user, defines the star rating
 */
function setRankings() {
  $('.rateYo').each(function() {
    let rating_ = parseFloat($(this).attr('data-rating'));
    rating_ = (rating_ / 10.0) * 5; // 5 stars rating
    $(this).rateYo({
      rating: rating_,
      starWidth: '17px',
      readOnly: true,
      multiColor: {
         'startColor': '#FF0000', // Red.
         'endColor': '#f1c40f',  // Yellow.
      },
    });
  });
}

/**
 * Function that rounds a number
 * @param n
 * @param digits
 * @returns {number}
 */
function roundTo(n, digits) {
  if (digits === undefined) {
    digits = 0;
  }

  let multiplicator = Math.pow(10, digits);
  n = parseFloat((n * multiplicator).toFixed(11));
  let test =(Math.round(n) / multiplicator);
  return +(test.toFixed(2));
}

/**
 * Facebook javascript sdk init
 */

window.fbAsyncInit = function() {
    FB.init({
        appId: '278916729224728',
        xfbml: true,
        version: 'v2.9',
    });
    FB.AppEvents.logPageView();
};

(function(d, s, id) {
    let js;
    let fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {
return;
}
    js = d.createElement(s); js.id = id;
    js.src = '//connect.facebook.net/en_US/sdk.js';
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));
