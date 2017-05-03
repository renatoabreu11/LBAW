let auctionId;

$(document).ready(function() {
  auctionId = $('input[name=auction-id]').val();

  $('.slider1').bxSlider({
    slideWidth: 200,
    minSlides: 2,
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
    }).magnificPopup('open');

    $('.bidOnAuction').one('click', function() {
      $.magnificPopup.close();
      let amount = $('#bidOnAuction').find('.bid-amount').val().trim();
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

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: BASE_URL + 'api/auction/bid.php',
      data: {
        'amount': amount,
        'auction-id': auctionId,
        'user-id': userId,
        'token': token,
      },
      success: function(data) {
        if(data['error']) {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + data['error'] + '</div>',
              type: 'inline',
            },
          });
        } else {
          currBid.text('Current Bid: ' + amount + '€');
          if(bidderTableBody.children().length === 5)
            bidderTableBody.children().last().remove();
          bidderTableBody.prepend('<tr><td class="col-xs-5"><a href="' + BASE_URL + 'pages/user/user.php?id=' + userId + '">' + username + '</a></td><td class="col-xs-2">' + amount + '</td><td class="col-xs-5">' + data['date'] + '</td></tr>');

          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + data['success'] + '</div>',
              type: 'inline',
            },
          });
        }
      },
    });
  }

  // Add auctions to watchlist.
  $('.btn-add-watchlist').click(function() {
    let notificationsVal = $(this).text();
    let glyphiconSpan = $('.auction-watchlist-glyphicon');
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
    });

    request.done(function(response, textStatus, jqXHR) {
      notificationsModal.modal('hide');

      if(response.indexOf('Success') >= 0)
        watchlistBtnDiv.html('<h4 class="text-center"><span class="glyphicon glyphicon-heart auction-watchlist-glyphicon" style="cursor:pointer;"></span><button class="btn btn-default btn-remove-auction-watchlist"> Remove from watch list</button></h4>');

      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + response + '</div>',
          type: 'inline',
        },
      });
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occured: ' +
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
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.indexOf('Success') >= 0)
        watchlistBtnDiv.html('<h4 class="text-center"><span class="glyphicon glyphicon-heart-empty auction-watchlist-glyphicon" style="cursor:pointer;"></span><button class="btn btn-default" data-toggle="modal" data-target="#watchlist-notification-modal"> Add to watch list</button></h4>');

      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">' + response + '</div>',
          type: 'inline',
        },
      });
    });

    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error('The following error occured: ' +
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
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + data['message'] + '</div>',
            type: 'inline',
          },
        });
        if (data['message'].includes('Success')) {
          $('#newQuestionForm').trigger('reset');
          qaSection.empty();
          qaSection.append(data['questionsDiv']);
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
    let questionArticle = $(form).closest('article');
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
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + data['message'] + '</div>',
            type: 'inline',
          },
        });
        if (data['message'].includes('Success')) {
          $('.newAnswerForm').remove();
          qaSection.empty();
          qaSection.append(data['questionsDiv']);
        }
      },
      error: function(data) {
        console.log(data);
      },
    });
  }

  qaSection.on('click', '.edit-question', function() {
    let parent = $(this).parents('.comment-meta');
    parent.siblings('.question-edit-display').toggle();
    parent.siblings('.question-display').toggle();
  });

  qaSection.on('click', '.btn-edit-question', function() {
    let editComment = $(this).prev().val();
    let parent = $(this).parents('.media-body');
    let questionId = $(this).closest('article').find('input[name=question-id]').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/question_edit.php',
      data: {
        'questionId': questionId,
        'comment': editComment,
        'userId': userId,
        'token': token,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        let questionDisplay = parent.children('.question-display');
        parent.children('.question-edit-display').toggle();
        questionDisplay.toggle();
        questionDisplay.find('p').html(editComment);
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

  // Edit answer.
  qaSection.on('click', '.edit-answer', function() {
    let parent = $(this).parents('.comment-meta');
    parent.siblings('.answer-edit-display').toggle();
    parent.siblings('.answer-display').toggle();
  });

  qaSection.on('click', '.btn-edit-answer', function() {
    let editComment = $(this).prev().val();
    let parent = $(this).parents('.media-body');
    let answerId = $(this).closest('article').find('input[name=answer-id]').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/answer_edit.php',
      data: {
        'answerId': answerId,
        'comment': editComment,
        'userId': userId,
        'token': token,
      },
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        let answerDisplay = parent.children('.answer-display');
        parent.children('.answer-edit-display').toggle();
        answerDisplay.toggle();
        answerDisplay.find('p').html(editComment);
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
      console.error('The following error occured: '
        + textStatus + ': ' + errorThrown);
    });
  });

  qaSection.on('click', '.removeQuestionPopup', function() {
    let questionArticle = $(this).closest('article');
    let questionClass = $(this).attr('class').split('id-');
    let questionAnswerDiv = questionArticle.parent();

    if(questionClass.length !== 2)
      return;

    let questionId = questionClass[1];

    $('.removeQuestionPopup').magnificPopup({
      type: 'inline',
      midClick: true,
    }).magnificPopup('open');

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
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        questionDiv.fadeOut(500, function() {
          questionDiv.remove();
        });
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
      console.error('The following error occured: '
        + textStatus + ': ' + errorThrown);
    });
  }

  qaSection.on('click', '.removeAnswerPopup', function() {
    let answerArticle = $(this).closest('article');
    let answerClass = $(this).attr('class').split('id-');
    if(answerClass.length !== 2)
      return;

    let answerId = answerClass[1];

    $('.removeAnswerPopup').magnificPopup({
      type: 'inline',
      midClick: true,
    }).magnificPopup('open');

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
    });

    request.done(function(response, textStatus, jqXHR) {
      if(response.includes('Success')) {
        article.fadeOut(500, function() {
          article.remove();
        });
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
      console.error('The following error occured: '
        + textStatus + ': ' + errorThrown);
    });
  }

  // Report question.
  $('.report-question').click(function() {
    let reportBtn = $(this);
    let questionId = $(this).closest('article').children().eq(0).val();

    $('.btn-send-question-' + questionId + '-report').click(function() {
      let comment = $('.report-question-' + questionId + '-comment').val();
      let closeBtn = $(this).closest('.modal-body').next().children().eq(0);

      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/auction/report_question.php',
        data: {
          'question-id': questionId,
          'comment': comment,
          'user-id': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        closeBtn.click();
        reportBtn.remove();

        if(response.indexOf('success') >= 0) {
            $.magnificPopup.open({
              items: {
                src: '<div class="white-popup">'
                + 'The report was delivered with success and the administrators will look into it. Thank you.'
                + '</div>',
                type: 'inline',
              },
            });
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
        console.error('The following error occured: ' +
          textStatus + ': ' + errorThrown);
      });
    });
  });

  // Report answer.
  $('.report-answer').click(function() {
    let reportBtn = $(this);
    let answerId = $(this).closest('article').children().eq(0).val();

    $('.btn-send-answer-' + answerId + '-report').click(function() {
      let comment = $('.report-answer-' + answerId + '-comment').val();
      let closeBtn = $(this).closest('.modal-body').next().children().eq(0);

      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/auction/report_answer.php',
        data: {
          'answer-id': answerId,
          'comment': comment,
          'user-id': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        closeBtn.click();
        reportBtn.remove();

        if(response.indexOf('success') >= 0) {
            $.magnificPopup.open({
              items: {
                src: '<div class="white-popup">'
                + 'The report was delivered with success and the administrators will look into it. Thank you.'
                + '</div>',
                type: 'inline',
              },
            });
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
        console.error('The following error occured: ' +
          textStatus + ': ' + errorThrown);
      });
    });
  });

  // Reply (toggles reply form).
  $('.reply-question').click(function() {
    $('.newAnswerForm').fadeToggle();
  });
});

function removeAuctionFromWatchlistHandler() {
  let watchlistBtnDiv = $('.watchlist-button');

  let request = $.ajax({
    type: 'POST',
    url: BASE_URL + 'api/auctions/delete_auction_watchlist.php',
    data: {
      'auctionId': auctionId,
      'userId': userId,
      'token': token,
    },
  });

  request.done(function(response, textStatus, jqXHR) {
    if(response.indexOf('Success') >= 0)
      watchlistBtnDiv.html('<h4 class="text-center"><span class="glyphicon glyphicon-heart-empty auction-watchlist-glyphicon" style="cursor:pointer;"></span><button class="btn btn-default" data-toggle="modal" data-target="#watchlist-notification-modal"> Add to watch list</button></h4>');

    $.magnificPopup.open({
      items: {
        src: '<div class="white-popup">' + response + '</div>',
        type: 'inline',
      },
    });
  });

  request.fail(function(jqXHR, textStatus, errorThrown) {
    console.error('The following error occured: ' +
      textStatus + ': ' + errorThrown);
  });
}
