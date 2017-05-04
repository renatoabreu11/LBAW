$(document).ready(function() {
  setCountdown();
  setPagination();
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
 * Sets best auctions pagination
 */
function setPagination() {
  let nrPages = parseInt($('#pagination').attr('data-nr_pages'));

  $('#pagination').twbsPagination({
    totalPages: nrPages,
    visiblePages: 7,
    onPageClick: function(event, page) {
      $('#pagination').attr('data-curr_page', page);
      showAuctionsOfAPage(page);
      window.scrollTo(0, 0);
    },
  });
}

/**
 * Show all auctions of a page.
 */
function showAuctionsOfAPage(page) {
  $('.auction_row').each(function() {
    let nrPage = parseInt($(this).attr('data-page'));
    if (nrPage == page)
      $(this).show();
    else
      $(this).hide();
  });
}

/**
 * Show all auctions of all pages.
 */
function showAllAuctions() {
  $('.auction_row').each(function() {
    $(this).show();
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

    showAllAuctions(); // tinysort dont sort hidden elements

    // thumbnail list
    if (id === 'priceLow')
      tinysort('#auctionsThumbnails>div', {attr: 'data-priceLow'});
    if (id === 'priceHigh')
      tinysort('#auctionsThumbnails>div', {attr: 'data-priceHigh'});
    if (id === 'popular')
      tinysort('#auctionsThumbnails>div', {attr: 'data-popular'});
    if (id === 'newest')
      tinysort('#auctionsThumbnails>div', {attr: 'data-newest'});
    if (id === 'ending')
      tinysort('#auctionsThumbnails>div', {attr: 'data-ending'});
    if (id === 'recentlyAdded') {
      console.log('oi');
      tinysort('#auctionsThumbnails>div', {attr: 'data-recentlyAdded'});
    }

    let page = $('#pagination').attr('data-curr_page');
    setAuctionsCurrPage();
    showAuctionsOfAPage(page);
  });
}

/**
 * Set attribute data-page of each auction element.
 */
function setAuctionsCurrPage() {
  let counter = 0;
  $('#auctions .auction_row').each(function() {
    let hisPage = Math.floor(counter/4)+1;
    $(this).attr('data-page', hisPage);
    counter++;
  });
  counter = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    let hisPage = Math.floor(counter/4)+1;
    $(this).attr('data-page', hisPage);
    counter++;
  });
}
