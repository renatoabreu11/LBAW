$(document).ready(function() {
  $('#menu-toggle').click(function(e) {
    e.preventDefault();
    $('#wrapper').toggleClass('toggled');
  });

  $(window).on('resize', function() {
    $('#wrapper').removeClass('toggled');
  });

  $('#newAdmin').validate({
    rules:
      {
        email: {
          email: true,
          required: true,
          maxlength: 64,
        },
        username: {
          required: true,
          maxlength: 64,
        },
        password: {
          required: true,
          minlength: 8,
          maxlength: 64,
        },
        confirm: {
          required: true,
          equalTo: $(this).find('#password'),
        },
      },
    messages:
      {
        username: {
          required: 'Please, enter the admin\'s username.',
          maxlength: 'The admin\'s username ' +
          'must be no more than 64 characters.',
        },
        password: {
          required: 'Please, enter the admin\'s password.',
          minlength: 'The admin\'s password ' +
          'should be between 8 and 64 characters.',
          maxlength: 'The admin\'s password ' +
          'should be between 8 and 64 characters.',
        },
        confirm: {
          required: 'Please, enter the password confirmation.',
          equalTo: 'The confirmation password does not match.',
        },
        email: {
          email: 'Please, enter the admin\'s email.',
          maxlength: 'The admin\'s email must be no more than 64 characters.',
        },
      },
    errorPlacement: function(error, element) {
      let parentDiv = $(element).parent('.input-group');
      error.insertAfter(parentDiv);
    },
    submitHandler: addAdmin,
  });

  /**
   * Ajax call that adds a new admin
   * @return {boolean}
   */
  function addAdmin() {
    let form = $('#newAdmin');
    let password = form.find('#password').val();
    let username = form.find('#username').val();
    let email = form.find('#email').val();
    let confirm = form.find('#confirm').val();
    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/add_admin.php',
      data: {
        'username': username,
        'password': password,
        'email': email,
        'confirm': confirm,
        'token': token,
        'adminId': adminId,
      },
      dataType: 'json',
      success: function(data) {
        form.find('.field_error.username').text('');
        form.find('.field_error.email').text('');

        let message = data['message'];
        let response = data['response'];

        if(message.includes('Invalid username characters.')
          || message.includes('Username already exists.')) {
          form.find('.field_error.username').text(message);
        } else if(message.includes('Email already exists.'))
          form.find('.field_error.email').text(message);
        else {
          $.magnificPopup.open({
            items: {
              src: '<div class="white-popup">' + message + '</div>',
              type: 'inline',
            },
          });
          if(response.includes('Success'))
            form.trigger('reset');
        }
      },
      error: function(data) {
        console.log(data);
      },
    });
    return false;
  }

  $('#newCategory').validate({
    rules: {
      title: {
        required: true,
        maxlength: 64,
      },
    },
    submitHandler: addCategory,
  });

  /**
   * Ajax call that adds a new category
   */
  function addCategory() {
    event.preventDefault();

    let form = $('#newCategory');
    let title = form.find('input[name=\'title\']').val();

    let request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/add_category.php',
      data: {
        'title': title,
        'token': token,
        'adminId': adminId,
      },
      dataType: 'json',
    });

    // Callback handler that will be called on success
    request.done(function(data, textStatus, jqXHR) {
      let message = data['message'];
      let response = data['response'];
      if(message.includes('Category already exists')) {
        form.find('.field_error').text(message);
      } else if(message.includes('Success')) {
        form.trigger('reset');
        let div = '<li class="list-group-item col-md-3">'
          +title+
          '<a class="removeCategoryPopup id-' + data['id'] + '" href="#removeCategoryConfirmation">'+
          '<i class="fa fa-times pull-right" aria-hidden="true"></i>'+
          '</a></li>';
        $('.categories ul').append(div);
      }else{
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + message + '</div>',
            type: 'inline',
          },
        });
      }
    });

    // Callback handler that will be called on failure
    request.fail(function(jqXHR, textStatus, errorThrown) {
      // Log the error to the console
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  }

  $('ul.list-group').on('click', 'a.removeCategoryPopup', function() {
    let categoryObject = $(this).closest('.list-group-item');
    let classArray = $(this).attr('class').split('id-');
    if(classArray.length > 2)
      return;

    let categoryId = classArray[1];

    $('.removeCategoryPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeCategory').off();
    $('.removeCategory').one('click', function() {
      $.magnificPopup.close();
      deleteCategory(categoryId, categoryObject);
    });
  });

  /**
   * Ajax call that deletes a category
   * @param {id} categoryId
   * @param {object} object
   */
  function deleteCategory(categoryId, object) {
    $.magnificPopup.close();
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/remove_category.php',
      data: {
        'id': categoryId,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success')) {
        object.hide('slow', function() {
          object.remove();
        });
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

  let auctionTable = $('#auctionsTable');
  auctionTable.DataTable();
  let userTable = $('#usersTable');
  userTable.DataTable();
  let reportTable = $('#reportsTable');
  reportTable.DataTable();

  /**
   * Ajax call that deletes an auction with the given id
   * @param {number} id
   */
  function deleteAuction(id) {
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/remove_auction.php',
      data: {
        'id': id,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success')) {
        auctionTable.DataTable().row('.selected').remove().draw(false);
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

  /**
   * Ajax call that deletes an user with the given id
   * @param {number} id
   */
  function deleteUser(id) {
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/remove_user.php',
      data: {
        'id': id,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success')) {
        userTable.DataTable().row('.selected').remove().draw(false);
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

  /**
   * Ajax call that deletes a report with the given id
   * @param {number} id
   * @param {string} type
   */
  function deleteReport(id, type) {
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/remove_report.php',
      data: {
        'id': id,
        'type': type,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success')) {
        reportTable.DataTable().row('.selected').remove().draw(false);
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

  $('.removePopup').on('click', function() {
    let row = auctionTable.find('tr.selected');
    let auctionId = row.find('td:first').html();

    if(auctionId === undefined)
      return;

    $('.removePopup').magnificPopup({
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

  $('.removeUserPopup').on('click', function() {
    let row = userTable.find('tr.selected');
    let userId = row.find('td:first').html();
    if(userId === undefined)
      return;

    $('.removeUserPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeUser').off();
    $('.removeUser').one('click', function() {
      $.magnificPopup.close();
      deleteUser(userId);
    });
  });

  $('.notifyUserPopup').on('click', function() {
    let row = userTable.find('tr.selected');
    let userId = row.find('td:first').html();
    if(userId === undefined)
      return;

    $('.notifyUserPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');
  });

  $('.removeReportPopup').on('click', function() {
    let row = reportTable.find('tr.selected');
    let reportId = row.find('td:first').html();
    if(reportId === undefined)
      return;

    let reportType = reportTable.find('th.reportType').html();
    let types = ['Answer', 'Auction', 'User', 'Question'];
    if(types.indexOf(reportType) === -1)
      return;

    $('.removeReportPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeReport').off();
    $('.removeReport').one('click', function() {
      $.magnificPopup.close();
      deleteReport(reportId, reportType);
    });
  });

  $('#notificationForm').validate({
    rules: {
      notification: {
        required: true,
        maxlength: 256,
      },
    },
    submitHandler: notifyUser,
  });

  /**
   * Ajax call that notifies an user
   */
  function notifyUser() {
    $.magnificPopup.close();
    let row = $('#usersTable').find('tr.selected');
    let id = row.find('td:first').html();
    let message = $('#notificationForm').find('textarea#notification').val();
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/notify_user.php',
      data: {
        'id': id,
        'message': message,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success'))
        $('#notificationForm').trigger('reset');
    });

    // Callback handler that will be called on failure
    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  }

  $('.showReports').on('click', function() {
    let selected = $('#report_type').val();
    let currentType = $('#reportsTable').find('th.reportType').html();
    if(selected === currentType)
      return;

    window.location.replace(BASE_URL +
      'pages/admin/reports.php?type=' + selected);
  });

  $('.closePopup').on('click', function() {
    $.magnificPopup.close();
  });

  auctionTable.find('tbody').on( 'click', 'tr', function() {
    if ( $(this).hasClass('selected') ) {
      $(this).removeClass('selected');
    } else {
      $('#auctionsTable').find('tr.selected').removeClass('selected');
      $(this).addClass('selected');
    }
  } );

  userTable.find('tbody').on( 'click', 'tr', function() {
    if ( $(this).hasClass('selected') ) {
      $(this).removeClass('selected');
    } else {
      $('#usersTable').find('tr.selected').removeClass('selected');
      $(this).addClass('selected');
    }
  } );

  reportTable.find('tbody').on( 'click', 'tr', function() {
    if ( $(this).hasClass('selected') ) {
      $(this).removeClass('selected');
    } else {
      $('#reportsTable').find('tr.selected').removeClass('selected');
      $(this).addClass('selected');
    }
  } );

  $('.removeFeedbackPopup').on('click', function() {
    let notificationObject = $(this).closest('div.notifications-wrapper');
    let parent = $(this).parent('.media-body');
    let feedId = parent.find('h5 span.feed_id').html();

    $('.removeFeedbackPopup').magnificPopup({
      type: 'inline',
      midClick: true,
      mainClass: 'mfp-fade',
    }).magnificPopup('open');

    $('.removeFeedback').off();
    $('.removeFeedback').one('click', function() {
      $.magnificPopup.close();
      deleteFeedback(feedId, notificationObject);
    });
  });

  /**
   * Ajax call that deletes a feedback message
   * @param {id} feedId
   * @param {object} object
   */
  function deleteFeedback(feedId, object) {
    $.magnificPopup.close();
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/remove_feedback.php',
      data: {
        'id': feedId,
        'token': token,
        'adminId': adminId,
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
        },
      });
      if(response.includes('Success')) {
        object.hide('slow', function() {
          object.remove();
        });
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

  $('.exportAuctions').on('click', function() {
    let request;
    request = $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/admin/export_auctions.php',
      data: {
        'token': token,
        'adminId': adminId,
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
        },
      });
    });

    // Callback handler that will be called on failure
    request.fail(function(jqXHR, textStatus, errorThrown) {
      console.error(
        'The following error occurred: '+
        textStatus, errorThrown
      );
    });
  });
});