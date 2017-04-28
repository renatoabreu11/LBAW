$(document).ready(function() {
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

  $('.auction_row').each(function() {
    $(this).show();
  });

  setRankings();
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
    });
  });
}
