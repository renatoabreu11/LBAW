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
        $(this).html('This offer has expired!')
          .parent().addClass('disabled');
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
   * @param {number} auctionId
   * @param {number} userId
   * @param {string} token
   */
  function bidOnAuction(amount) {
    let currBid = $('.current-bid');
    let bidderTableBody = $('.bidders-table-body');
    let username = $('input[name=user-username]').val();

    let request = $.ajax({
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
          currBid.text("Current Bid: " + amount + "€");
          if(bidderTableBody.children().length == 5)
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

  // Send question.
  $('.btn-send-question').click(function() {
    let comment = $('.question-area').val();
    let auctionId = $('input[name=auction-id]').val();

    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: BASE_URL + 'api/auction/create_question.php',
      data: {
        'comment': comment,
        'auction-id': auctionId,
        'token': token,
        'user-id': userId,
      },
      success: function(data) {
        if(data['error']) {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + data['error'] + '</div>',
              type: 'inline',
            },
          });
        } else
          var content = '<article class="row"> <div class="col-md-1 col-sm-1 hidden-xs"> <figure class="thumbnail"> <img class="img-responsive" src="' + BASE_URL + 'images/users/' + data['profile_pic'] + '" /> </figure> </div> <div class="col-md-10 col-sm-10 col-xs-12"> <div class="panel panel-default arrow left"> <div class="panel-body"> <div class="media-heading"> <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button> <a href="' + BASE_URL + ' pages/user/user.php?id=' + userId + '"><strong>' + data['username'] + '</strong></a> ' + data['date'] + ' </div> <div class="panel-collapse collapse in" id="collapseComment"> <div class="media-body"> <p>' + data['comment'] + '</p> <div class="comment-meta"> <span><a href="#">delete</a></span> <span><a href="#">report</a></span> <span><a href="#">hide</a></span> <span><a href="#">reply</a></span> </div> </div> </div> </div> </div> </div> </article>';
        $(content).hide().appendTo('.comment-list').fadeIn(500);
      },
    });
  });

  // Send answer.
  $('.btn-answer-question').click(function() {
    let comment = $(this).prev().children().eq(0).val();
    let questionArticle = $(this).closest('article');
    let questionId = questionArticle.children().eq(0).val();
    let replyBtn = $(this).parent().prev().children('.reply-question'); ;
    let form = $(this).parent();

    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auction/create_answer.php',
      dataType: 'json',
      data: {
        'token': token,
        'user-id': userId,
        'comment': comment,
        'question-id': questionId,
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
          let content = '<article class="row"><div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs"><figure class="thumbnail"><img class="img-responsive" src="' + BASE_URL + 'images/users/' + data['profile_pic'] + '"/></figure></div><div class="col-md-9 col-sm-9 col-sm-offset-0 col-md-offset-0 col-xs-offset-1 col-xs-11"><div class="panel panel-default arrow left"><div class="panel-body"><div class="media-heading"><button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseReply"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button><a href="' + BASE_URL + 'pages/user/user.php?id=' + userId + '"><strong>' + data['username'] + '</strong></a>' + data['date'] + '</div><div class="panel-collapse collapse in" id="collapseReply"><div class="media-body"><p>' + comment + '</p><div class="comment-meta"><span><a href="#">delete</a></span><span><a href="#">report</a></span><span><a href="#">hide</a></span>                        </div>                    </div>                </div>            </div>        </div>    </div></article>';
          $(content).hide().appendTo(questionArticle).fadeIn(500);
          replyBtn.fadeOut(500, function() {
            replyBtn.remove();
          });
          form.remove();
        }
      },
    });
  });

  // Edit question.
  $('.edit-question').click(function() {
    let questionMessageHTML = $(this).parent().prev().children();
    let comment = questionMessageHTML.eq(0).text();
    let content =
      '<textarea name="updated-question" class="form-control answer-area" rows="3">'
      + comment
      + '</textarea>' +
      '<button type="submit" class="btn btn-default btn-edit-question">Send</button>';
    let questionId = $(this).closest('article').children().eq(0).val();

    questionMessageHTML.html(content);

    $('.btn-edit-question').click(function() {
      let editComment = $(this).prev().val();
      let questionMessageEditHTML = $(this).parent();

      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/auction/question_edit.php',
        data: {
          'question-id': questionId,
          'comment': editComment,
          'user-id': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        if(response.indexOf('success') >= 0) {
          let editContent = '<p>' + editComment + '</p>';
          questionMessageEditHTML.html(editContent);
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

  // Edit answer.
  $('.edit-answer').click(function() {
    let answerMessageHTML = $(this).parent().prev().children();
    let comment = answerMessageHTML.eq(0).text();
    let content =
      '<textarea name="updated-answer" class="form-control answer-area" rows="3">'
      + comment
      + '</textarea>' +
      '<button type="submit" class="btn btn-default btn-edit-answer">Send</button>';
    let answerId = $(this).closest('article').children().eq(0).val();

    answerMessageHTML.html(content);

    $('.btn-edit-answer').click(function() {
      let editComment = $(this).prev().val();
      let answerMessageEditHTML = $(this).parent();

      let request = $.ajax({
        type: 'POST',
        url: BASE_URL + 'api/auction/answer_edit.php',
        data: {
          'answer-id': answerId,
          'comment': editComment,
          'user-id': userId,
          'token': token,
        },
      });

      request.done(function(response, textStatus, jqXHR) {
        if(response.indexOf('success') >= 0) {
          let editContent = '<p>' + editComment + '</p>';
          answerMessageEditHTML.html(editContent);
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
  });

  $('.removeQuestionPopup').on('click', function() {
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

  $('.removeAnswerPopup').on('click', function() {
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
      console.info(response);
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

  // Report anwser.
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

  // Hides the reply box.
  $('.new-answer').toggle();

  // Reply (toggles reply form).
  $('.reply-question').click(function() {
    $(this).parent().next().toggle();
  });
});
