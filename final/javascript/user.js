$(document).ready(function() {
  /**
   * Handles the 'Win' info when on hand devices.
   */
  if($(window).width() <= 768) {
    let wins = $('#wins');
    wins.find('.win-wrapper').removeClass('col-lg-3').removeClass('col-md-3');
    wins.find('.win-wrapper #win-info-image').addClass('col-sm-6');
    wins.find('.win-wrapper #win-info-text').addClass('col-sm-6');
    wins.find('.win-info').removeClass('text-right').addClass('text-center');
    wins.find('.win-image').width(156);
  }

  $('.clock').each(function() {
    let date = $(this).find('p').text();
    $(this).countdown(date)
      .on('update.countdown', function(event) {
        let format = '%Hh:%Mm:%Ss';
        if(event.offset.totalDays > 0) {
          format = '%-d day%!d ' + format;
        }
        if(event.offset.weeks > 0) {
          format = '%-w week%!w ' + format;
        }
        $(this).html(event.strftime(format));
      })
      .on('finish.countdown', function(event) {
        $(this).html('This offer has expired!').parent().addClass('disabled');
      });
  });

  // Used when an user clicks the reviews on an auction page. This way it will be redirected to the
  // review tab.
  let hash = document.location.hash;
  if (hash)
      $('.nav-tabs a[href="'+hash+'"]').tab('show');
  // Change hash for page-reload
  $('.nav-tabs a').on('shown.bs.tab', function(e) {
      window.location.hash = e.target.hash;
  });

  /**
   * Follow/Unfollow button (below the basic details).
   */
  $('#follow-btn').click(function() {
    let followedUserId = $('#details').find('.details-short-info-member-number').text();
    let btnText = $(this).text();

    let request;
    if(btnText === 'Follow') {
      request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/follow.php',
        data: {
          'followedUserId': followedUserId,
          'userId': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        if(response.includes('Success'))
          $('#follow-btn').html('Unfollow');
      });

      request.fail(function(jqXHR, textStatus, errorThrown) {
        console.error('The following error occurred: '
          + textStatus + ': ' + errorThrown);
      });
    } else {
      request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/unfollow.php',
        data: {
          'unfollowedUserId': followedUserId,
          'userId': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        if(response.includes('Success'))
          $('#follow-btn').html('Follow');
      });

      request.fail(function(jqXHR, textStatus, errorThrown) {
        console.error('The following error occurred: '
          + textStatus + ': ' + errorThrown);
      });
    }
  });

  /**
   * Unfollow button (using tabs).
   */
  $('#following').find('.btn').click(function() {
    let followedUserId = $(this).parent().prev()
      .children('a').eq(0).attr('href');
    let firstIndex = followedUserId.lastIndexOf('id=');
    let id = followedUserId.substring(firstIndex+3);
    let mediaObj = $(this).parent().parent();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/unfollow.php',
      data: {
        'unfollowedUserId': id,
        'userId': userId,
        'token': token,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      console.info('Response: ' + response);
      if(response.includes('Success')) {
        mediaObj.fadeOut(500, function() {
          mediaObj.remove();

          // Updates badge number.
          let badge = $('.following-badge');
          let currBadgeNum = badge.html();
          badge.html(parseInt(currBadgeNum, 10)-1);

          // If there's no more followed users, changes html.
          let followingDiv = $('#following');
          if(followingDiv.children().length === 0)
            followingDiv.html('<p>No users being followed.</p>');
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  });

  /**
   * Review auction
   */
  $('#wins').find('.win-review-rating-stars .glyphicon').mouseover(function() {
    $(this).removeClass('glyphicon-star-empty').addClass('glyphicon-star');
    $(this).prevAll().removeClass('glyphicon-star-empty')
      .addClass('glyphicon-star');
    $(this).nextAll().removeClass('glyphicon-star')
      .addClass('glyphicon-star-empty');
  });

  /**
   * Review submit button.
   */
  $('.btn-review-submit').click(function() {
    let rating = $(this).prev().prev().children('.win-review-rating-stars')
      .children('.glyphicon-star').length;
    let message = $(this).prev().children('textarea').val();
    let bidId = $(this).prev().prev().prev().val();
    let formWrapper = $(this).parent().parent();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/review_auction.php',
      data: {
        'rating': rating,
        'message': message,
        'bidId': bidId,
        'userId': userId,
        'token': token,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      console.info('Insert review response: ' + response);
      if(response.includes('Success')) {
        // Removes the form wrapper.
        formWrapper.fadeOut(500, function() {
          formWrapper.remove();
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  });


  $('.closePopup').on('click', function() {
    $.magnificPopup.close();
  });

  let notificationsWrapper = $('.notificationsPage .notifications-wrapper');
  notificationsWrapper.on('click', '.readNotification', function() {
    let notificationClass = $(this).attr('class').split('id-');
    if (notificationClass.length === 2) {
      let object = $(this).closest('.notifications-wrapper');
      let notificationId = notificationClass[1];
      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/read_notification.php',
        data: {
          'notification': notificationId,
          'token': token,
          'userId': userId,
        },
      });

      // Callback handler that will be called on success
      request.done(function(response, textStatus, jqXHR) {
        if (response.includes('Success')) {
          $('<a href="#" data-toggle="tooltip" title="Notification read!"><i class="fa fa-eye" aria-hidden="true"></i></a>').insertAfter(object.find('.media-body small'));
          object.find('span a.readNotification').remove();
        }else {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + response + '</div>',
              type: 'inline',
            },
          });
        }
      });
    }
  });

  notificationsWrapper.on('click', '.removeNotificationPopup', function() {
    let notificationClass = $(this).attr('class').split('id-');
    if (notificationClass.length === 2) {
      let object = $(this).closest('.notifications-wrapper');
      let notificationId = notificationClass[1];
      $('.removeNotificationPopup').magnificPopup({
        type: 'inline',
        midClick: true,
        mainClass: 'mfp-fade',
      }).magnificPopup('open');

      $('.removeNotification').off();
      $('.removeNotification').one('click', function() {
        $.magnificPopup.close();
        deleteNotification(notificationId, object);
      });
    }
  });

  /**
   * Handles the call to delete a notification
   * @param {number} notificationId
   * @param {object} object
   */
  function deleteNotification(notificationId, object) {
    $.magnificPopup.close();
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/delete_notification.php',
      data: {
        'id': notificationId,
        'token': token,
        'userId': userId,
      },
      dataType: 'text',
    });

    // Callback handler that will be called on success
    request.done(function(response, textStatus, jqXHR) {
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + response + '</div>',
          type: 'inline',
        },
      });
      if(response.includes('Success')) {
        notificationsWrapper = $('.notificationsPage .notifications-wrapper');
        object.hide('slow', function() {
          object.remove();
        });
        if(notificationsWrapper.length === 1) {
          window.location.href=window.location.href;
        }
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

  $('.reportUserPopup').magnificPopup({
    type: 'inline',
    midClick: true,
    mainClass: 'mfp-fade',
  });

  $('#reportUserForm').validate({
    rules: {
      reportUserMessage: {
        required: true,
        maxlength: 512,
      },
    },
    submitHandler: reportUser,
  });

  /**
   * Ajax call that reports an user
   */
  function reportUser(form) {
    $.magnificPopup.close();
    let comment = $('#reportUserMessage').val();
    let reportedUserId = $(form).find('input[name=reportedUserId]').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/report_user.php',
      data: {
        'reportedUserId': reportedUserId,
        'comment': comment,
        'userId': userId,
        'token': token,
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
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  }
});