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
          src: '<div class="white-popup">Error 400 Bad Request: You cannot add this amount of money. The maximum is 1000€.</div>',
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
      success: function(data) {
        let currCredit = $('#currCredit').attr('data-currCredit');
        currCredit = parseFloat(currCredit) + parseFloat(creditToAdd);
        $('#currCredit').attr('data-currCredit', currCredit);
        $('#currCredit').text(currCredit + ' €');
        $.magnificPopup.open({
          items: {
            src: '<div class="white-popup">' + data + '</div>',
            type: 'inline',
            mainClass: 'mfp-fade',
          },
        });
      },
      error: function(data) {
        alert(data);
      },
    });
  });
}
