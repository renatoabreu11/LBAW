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

  /**
   * Follow/Unfollow button (below the basic details).
   */
  $('#follow-btn').click(function() {
    let userId = $('#details').find('.details-short-info-member-number').text();
    let btnText = $(this).text();

    let request;
    if(btnText === 'Follow') {
      request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/follow.php',
        data: {
          'followedUserId': userId,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        console.info('Response: ' + response);
        if(response.indexOf('success') >= 0)
          $('#follow-btn').html('Unfollow');
      });

      request.fail(function(jqXHR, textStatus, errorThrown) {
        console.error('The following error occured: '
          + textStatus + ': ' + errorThrown);
      });
    } else {
      request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/user/unfollow.php',
        data: {
          'followedUserId': userId,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        console.info('Response: ' + response);
        if(response.indexOf('success') >= 0)
          $('#follow-btn').html('Follow');
      });

      request.fail(function(jqXHR, textStatus, errorThrown) {
        console.error('The following error occured: '
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
        'followedUserId': id,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      console.info('Response: ' + response);
      if(response.indexOf('success') >= 0) {
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
      console.error('The following error occured: '
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
        'bid_id': bidId,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      console.info('Insert review response: ' + response);
      if(response.indexOf('success') >= 0) {
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

  // set star ratings of user
  $('.rateYo').each(function() {
    let rating_ = parseFloat($(this).attr('data-rating'));
    rating_ = (rating_ / 10.0) * 5; // 5 stars rating
    $(this).rateYo({
      rating: rating_,
      starWidth: '17px',
      readOnly: true,
    });
  });
});
