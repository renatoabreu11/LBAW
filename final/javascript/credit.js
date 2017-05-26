$(document).ready(function() {
  setCreditInput();
  setAddCredit();
});

/**
 * Set credit input.
 */
function setCreditInput() {
  $('.number-spinner button').click(function() {
    let btn = $(this);
    let	oldValue = $('#creditToAdd').val().trim();
    let	newVal = 0;

    if (btn.attr('data-dir') === 'up')
      newVal = parseInt(oldValue) + 1;
    else {
      if (oldValue > 1)
        newVal = parseInt(oldValue) - 1;
      else
        newVal = 1;
    }
    $('#creditToAdd').val(newVal);
  });
}

/**
 * Set the adding credit function.
 */
function setAddCredit() {
  $('#addCreditBtn').click(function() {
    let creditToAdd = roundTo($('#creditToAdd').val().trim(), 2);
    if (isNaN(creditToAdd))
      return;

    if(creditToAdd > 1000) {
      $.magnificPopup.open({
        items: {
          src: '<div class="white-popup">You cannot add this amount of money. The maximum allowed is 1000€.</div>',
          type: 'inline',
          mainClass: 'mfp-fade',
        },
      });
      return;
    }

    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/user/add_credit.php',
      data: {
        'creditToAdd': creditToAdd,
        'userId': userId,
        'token': token,
      },
      dataType: 'json',
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if(response.includes('Success')){
          let currCredit = $('#currCredit').attr('data-currCredit');
          currCredit = parseFloat(currCredit) + parseFloat(creditToAdd);
          $('#currCredit').attr('data-currCredit', currCredit);
          $('#currCredit').text(currCredit + ' €');
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
        alert(data);
      },
    });
  });
}
