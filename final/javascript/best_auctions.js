$(document).ready(function() {
  setCountdown();
  $('.auction_row').each(function() {
    $(this).show();
  });
  setRankings();
  setSorting();
});

/**
 * For each date, initializes the respective countdown
 */
function setCountdown() {
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
}

/**
 * Set sorting filters.
 */
function setSorting() {
  $('.auctionSort li').click(function() {
    $('.auctionSort li').removeClass('active');
    $(this).addClass('active');
    let id = this.id;

    // normal list
    if (id === 'priceLow')
      tinysort('#bodyToSort>tr', {attr: 'data-priceLow'});
    if (id === 'priceHigh')
      tinysort('#bodyToSort>tr', {attr: 'data-priceHigh'});
    if (id === 'popular')
      tinysort('#bodyToSort>tr', {attr: 'data-popular'});
    if (id === 'newest')
      tinysort('#bodyToSort>tr', {attr: 'data-newest'});
    if (id === 'ending')
      tinysort('#bodyToSort>tr', {attr: 'data-ending'});
  });
}

