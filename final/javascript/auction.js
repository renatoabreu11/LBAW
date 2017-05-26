let auctionId;

$(document).ready(function() {
  auctionId = $('input[name=auction-id]').val();
  let seller = $('input[name=seller]').val();

  $('.popup-gallery').magnificPopup({
    delegate: 'a',
    type: 'image',
    tLoading: 'Loading image #%curr%...',
    mainClass: 'mfp-img-mobile',
    gallery: {
      enabled: true,
      navigateByImgClick: true,
      preload: [0, 1], // Will preload 0 - before current, and 1 after the current image
    },
    image: {
      tError: '<a href="%url%">The image #%curr%</a> could not be loaded.',
      titleSrc: function(item) {
        return item.el.attr('title') + '<small>by ' + seller + '</small>';
      },
    },
  });

  $('.slider1').bxSlider({
    slideWidth: 200,
    minSlides: 1,
    maxSlides: 4,
    slideMargin: 15,
  });

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

  $('.number-spinner').on('click', 'button', function() {
    let btn = $(this);
    let oldValue = btn.closest('.number-spinner').find('input').val().trim();
    let newVal = 0;

    if (btn.attr('data-dir') === 'up') {
      newVal = parseInt(oldValue) + 1;
    } else {
      if (oldValue > 1) {
        newVal = parseInt(oldValue) - 1;
      } else {
        newVal = 1;
      }
    }
    let minValue = btn.closest('.number-spinner').find('input').attr('min');
    if(minValue > newVal) {
      btn.closest('.number-spinner').find('input').val(minValue);
    } else btn.closest('.number-spinner').find('input').val(newVal);
  });

  $('.closePopup').on('click', function() {
    $.magnificPopup.close();
  });

  $('.binOnAuctionPopup').on('click', function() {
    $('.binOnAuctionPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.bidOnAuction').off();
    $('.bidOnAuction').one('click', function() {
      $.magnificPopup.close();
      let amount = roundTo($('#bidOnAuction').find('.bid-amount').val().trim(), 2);
      bidOnAuction(amount);
    });
  });

  /**
   * Handles the bid ajax call and updates the current bid value accordingly to the response;
   * @param {number} amount
   */
  function bidOnAuction(amount) {
    let currBid = $('.current-bid');
    let bidderTableBody = $('.bidders-table-body');
    let username = $('input[name=user-username]').val();
    let biddersDiv = $('.info');
    let auctionDetailsDiv = $('.auctionDetails');
    let hasBidders = $('html').has('.bidders-table-body').length;

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: BASE_URL + 'api/auction/bid.php',
      data: {
        'amount': amount,
        'auctionId': auctionId,
        'userId': userId,
        'token': token,
      },
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if(response.includes('Error') || response.includes('Success 203')) {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + message + '</div>',
              type: 'inline',
            },
          });
        } else if(response.includes('Success 201')) {
          $('input.bid-amount').val(amount + 1);
          $('input.bid-amount').attr({
            'min': amount + 1,
          });
          currBid.text('Current Bid: ' + amount + '€');
          if (hasBidders) {
            if (bidderTableBody.children().length === 5)
              bidderTableBody.children().last().remove();
            bidderTableBody.prepend('' +
              '<tr>' +
              '<td class="col-xs-5">' +
              '<a href="' + BASE_URL + 'pages/user/user.php?id=' + userId + '">' + username + '</a>' +
              '</td>' +
              '<td class="col-xs-2">' + amount + '</td>' +
              '<td class="col-xs-5">' + data['date'] + '</td>' +
              '</tr>');
          } else {
            $.magnificPopup.open({
              items: {
                src: '<div class="white-popup">Congratulations. You\'re the first bidder of this auction</div>',
                type: 'inline',
              },
            });
            auctionDetailsDiv.removeClass('col-md-12').addClass('col-md-6');
            biddersDiv.append(data['biddersDiv']);
          }
        }
      },
    });
  }

  // Add auctions to watchlist.
  $('.btn-add-watchlist').click(function() {
    let notificationsVal = $(this).text();
    let notificationsModal = $(this).closest('#watchlist-notification-modal');
    let watchlistBtnDiv = $('.watchlist-button');

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auctions/add_auction_watchlist.php',
      data: {
        'auctionId': auctionId,
        'notifications': notificationsVal,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      notificationsModal.modal('hide');

      if(response.includes('Success'))
        watchlistBtnDiv.html('<h4 class="text-center"><span class="glyphicon glyphicon-heart auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default btn-remove-auction-watchlist" style="border: none;">Remove from watch list</button></h4>');
      else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
            type: 'inline',
          },
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  });

  // Remove auction from watchlist.
  $('.watchlist-button').on('click', '.btn-remove-auction-watchlist', function() {
    let watchlistBtnDiv = $('.watchlist-button');

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auctions/delete_auction_watchlist.php',
      data: {
        'auctionId': auctionId,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success'))
        watchlistBtnDiv.html('<h4 class="text-center"><span class="glyphicon glyphicon-heart-empty auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default" data-toggle="modal" data-target="#watchlist-notification-modal" style="border: none;">Add to watch list</button></h4>');
      else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
            type: 'inline',
          },
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  });

  let qaSection = $('#qaSection');
  $('#newQuestionForm').validate({
    rules:
      {
        comment: {
          required: true,
          maxlength: 512,
        },
      },
    messages:
      {
        comment: {
          required: 'Please, enter your question.',
          maxlength: 'The length of this question exceeds the maximum value of 512 characters.',
        },
      },
    errorPlacement: function(error, element) {
      error.insertAfter(element);
    },
    submitHandler: createQuestion,
  });

  /**
   * Function that makes an ajax call to create a new question
   */
  function createQuestion() {
    let comment = $('.question-area').val();
    let auctionId = $('input[name=auction-id]').val();

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: BASE_URL + 'api/auction/create_question.php',
      data: {
        'comment': comment,
        'auctionId': auctionId,
        'token': token,
        'userId': userId,
      },
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if (response.includes('Success')) {
          $('#newQuestionForm').trigger('reset');
          qaSection.empty();
          qaSection.append(data['questionsDiv']);
        }else {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + message + '</div>',
              type: 'inline',
            },
          });
        }
      },
      error: function(data) {
        console.log(data);
      },
    });
  }

  $('.newAnswerForm').validate({
    rules:
      {
        comment: {
          required: true,
          maxlength: 512,
        },
      },
    messages:
      {
        comment: {
          required: 'Please, enter your question.',
          maxlength: 'The length of this answer exceeds the maximum value of 512 characters.',
        },
      },
    errorPlacement: function(error, element) {
      error.insertAfter(element);
    },
    submitHandler: createAnswer,
  });

  /**
   * Function that makes an ajax call to create a new answer
   */
  function createAnswer(form) {
    let comment = $(form).find('textarea[name=comment]').val();
    let questionArticle = $(form).closest('.questionArticle');
    let questionId = questionArticle.find('input[name=question-id]').val();
    let auctionId = $('input[name=auction-id]').val();

    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/create_answer.php',
      dataType: 'json',
      data: {
        'token': token,
        'userId': userId,
        'comment': comment,
        'questionId': questionId,
        'auctionId': auctionId,
      },
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if (response.includes('Success')) {
          $('.newAnswerForm').remove();
          qaSection.empty();
          qaSection.append(data['questionsDiv']);
        }else {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + message + '</div>',
              type: 'inline',
              mainClass: 'mfp-fade',
            },
          });
        }
      },
      error: function(data) {
        console.log(data);
      },
    });
  }

  qaSection.on('click', '.edit-question', function() {
    let parent = $(this).closest('.comment-meta');
    parent.siblings('.question-edit-display').toggle();
    parent.siblings('.question-display').toggle();
  });

  qaSection.on('click', '.btn-edit-question', function() {
    let editComment = $(this).prev().val();
    let parent = $(this).closest('.media-body');
    let questionId = $(this).closest('.questionArticle').find('input[name=question-id]').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/question_edit.php',
      data: {
        'questionId': questionId,
        'comment': editComment,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        let questionDisplay = parent.children('.question-display');
        parent.children('.question-edit-display').toggle();
        questionDisplay.toggle();
        questionDisplay.find('p').html(editComment);
      } else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
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

  // Edit answer.
  qaSection.on('click', '.edit-answer', function() {
    let parent = $(this).closest('.comment-meta');
    parent.siblings('.answer-edit-display').toggle();
    parent.siblings('.answer-display').toggle();
  });

  qaSection.on('click', '.btn-edit-answer', function() {
    let editComment = $(this).prev().val();
    let parent = $(this).closest('.media-body');
    let answerId = $(this).closest('.answerArticle').find('input[name=answer-id]').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/answer_edit.php',
      data: {
        'answerId': answerId,
        'comment': editComment,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        let answerDisplay = parent.children('.answer-display');
        parent.children('.answer-edit-display').toggle();
        answerDisplay.toggle();
        answerDisplay.find('p').html(editComment);
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

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  });

  qaSection.on('click', '.removeQuestionPopup', function() {
    let questionArticle = $(this).closest('.questionArticle');
    let questionClass = $(this).attr('class').split('id-');
    let questionAnswerDiv = questionArticle.parent();

    if(questionClass.length !== 2)
      return;

    let questionId = questionClass[1];

    $('.removeQuestionPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeQuestion').off();
    $('.removeQuestion').one('click', function() {
      $.magnificPopup.close();
      deleteQuestion(questionId, questionAnswerDiv);
    });
  });

  /**
   * Makes an ajax call to delete a question
   * @param {number} questionId
   * @param {object} questionDiv
   */
  function deleteQuestion(questionId, questionDiv) {
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/question_delete.php',
      data: {
        'questionId': questionId,
        'userId': userId,
        'adminId': adminId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        questionDiv.fadeOut(500, function() {
          questionDiv.remove();
        });
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

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  }

  qaSection.on('click', '.removeAnswerPopup', function() {
    let answerArticle = $(this).closest('.answerArticle');
    let answerClass = $(this).attr('class').split('id-');
    if(answerClass.length !== 2)
      return;

    let answerId = answerClass[1];

    $('.removeAnswerPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');
    $('.removeAnswer').off();

    $('.removeAnswer').one('click', function() {
      $.magnificPopup.close();
      deleteAnswer(answerId, answerArticle);
    });
  });

  /**
   * Handles the ajax call to delete an answer
   * @param {number} answerId
   * @param {object} article
   */
  function deleteAnswer(answerId, article) {
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/answer_delete.php',
      data: {
        'answerId': answerId,
        'userId': userId,
        'adminId': adminId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        article.fadeOut(500, function() {
          article.remove();
        });
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

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: '
        + textStatus + ': ' + errorThrown);
    });
  }

  let reportQuestionId;
  $('.product-questions').on('click', '.reportQuestionPopup', function() {
    $('.reportQuestionPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    reportQuestionId = $(this).closest('.questionArticle').find('input[name=question-id]').val();
  });

  $('#reportQuestionForm').validate({
    rules: {
      reportQuestionMessage: {
        required: true,
        maxlength: 512,
      },
    },
    submitHandler: reportQuestion,
  });

  /**
   * Ajax call that reports a question
   */
  function reportQuestion() {
    if(reportQuestionId === -1)
      return;
    $.magnificPopup.close();
    let comment = $('#reportQuestionMessage').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/report_question.php',
      data: {
        'questionId': reportQuestionId,
        'comment': comment,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        $('#reportQuestionForm').trigger('reset');
        reportQuestionId = -1;
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
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  }

  let reportAnswerId;
  $('.product-questions').on('click', '.reportAnswerPopup', function() {
    $('.reportAnswerPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    reportAnswerId = $(this).closest('.answerArticle').find('input[name=answer-id]').val();
  });

  $('#reportAnswerForm').validate({
    rules: {
      reportAnswerMessage: {
        required: true,
        maxlength: 512,
      },
    },
    submitHandler: reportAnswer,
  });

  /**
   * Ajax call that reports an answer
   */
  function reportAnswer() {
    if(reportAnswerId === -1)
      return;
    $.magnificPopup.close();
    let comment = $('#reportAnswerMessage').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/report_answer.php',
      data: {
        'answerId': reportAnswerId,
        'comment': comment,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success')) {
        $('#reportAnswerForm').trigger('reset');
        reportAnswerId = -1;
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
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  }

  $('.reportAuctionPopup').magnificPopup({
    type: 'inline',
    midClick: true,
    mainClass: 'mfp-fade',
  });

  $('#reportAuctionForm').validate({
    rules: {
      reportAuctionMessage: {
        required: true,
        maxlength: 512,
      },
    },
    submitHandler: reportAuction,
  });

  /**
   * Ajax call that reports an auction
   */
  function reportAuction(form) {
    $.magnificPopup.close();
    let comment = $('#reportAuctionMessage').val();
    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/report_auction.php',
      data: {
        'auctionId': auctionId,
        'comment': comment,
        'userId': userId,
        'token': token,
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
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  }

  $('.auction').on('click', 'a.removeAuctionPopup', function() {
    $('.removeAuctionPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeAuction').off();
    $('.removeAuction').one('click', function() {
      $.magnificPopup.close();
      deleteAuction(auctionId);
    });
  });

  /**
   * Ajax call that deletes an auction
   * @param auctionId
   */
  function deleteAuction(auctionId) {
    let productId = $('input[name=product-id]').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/auction_delete.php',
      data: {
        'auctionId': auctionId,
        'productId': productId,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
    });

    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(response.includes('Success'))
        window.location.replace(BASE_URL);
      else {
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
            type: 'inline',
            mainClass: 'mfp-fade',
          },
        });
      }
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occurred: ' +
        textStatus + ': ' + errorThrown);
    });
  }

  // Reply (toggles reply form).
  $('.reply-question').click(function() {
    $('.newAnswerForm').fadeToggle();
  });

  // Facebook Share
  $('#social-fb').click(function() {
      FB.ui({
          method: 'share',
          display: 'popup',
          hashtag: '#SeekBid',
          href: 'http://gnomo.fe.up.pt/~lbaw1662/final/pages/auction/auction.php?id=' + auctionId,
      }, function(response) {});
  });
});
