$(document).ready(function() {
  setCountdown();
  setPagination();
  setRankings();
  setSorting();
  setFilter();
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
  if (nrPages == 0) {
    return;
  }

  $('#pagination').twbsPagination({
    totalPages: nrPages,
    visiblePages: 7,
    onPageClick: function(event, page) {
      $('#pagination').attr('data-curr_page', page);
      showAuctionsOfAPage(page);
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
 * Hide all auctions of all pages.
 */
function hideAllAuctions() {
  $('.auction_row').each(function() {
    $(this).hide();
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
    if (id === 'recentlyAdded')
      tinysort('#auctionsThumbnails>div', {attr: 'data-recentlyAdded'});

    let currPage = 1;
    $('#pagination').attr('data-curr_page', currPage);
    setPagesOfAuctions();
    $('#pagination').twbsPagination('destroy');
    setPagination();
    showAuctionsOfAPage(currPage);
  });
}

/**
 * Set attribute data-page of each auction element.
 */
function setPagesOfAuctions() {
  let counter = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    let hisPage = Math.floor(counter/4)+1;
    $(this).attr('data-page', hisPage);
    counter++;
  });
}

/**
 * Set filte of auctions in watchlist
 */ 
function setFilter() {
  $('.selectpicker').on('change', function(){
    let selected = $(this).find("option:selected").val();
    
    $('#pagination').attr('data-nr_pages', 0);
    hideAllAuctions();
    showAuctionsSpecifiedInFilter(selected);
   
    let numPages = getNumPagesNecessaryToVisibleAuctions();
    $('#pagination').attr('data-nr_pages', numPages);
    setPagesOfVisibleAuctions();

    let currPage = 1
    $('#pagination').attr('data-curr_page', currPage);
    $('#pagination').twbsPagination('destroy');
    setPagination();
  });
}

/**
 * Show auctions based on the selected option of filter.
 */
function showAuctionsSpecifiedInFilter(selected) {
  if (selected == "All auctions") {
    showAllAuctions();
  }
  else if (selected == "My auctions") {
    $('#auctionsThumbnails .auction_row').each(function() {
      let myAuction = $(this).attr('data-myAuction');
      if (myAuction == 1)
        $(this).show();
    });
  }
  else if (selected == "Closed auctions") {
    $('#auctionsThumbnails .auction_row').each(function() {
      let myAuction = $(this).attr('data-active');
      if (myAuction == 0) 
        $(this).show();
    });
  }
  else if (selected == "Open auctions") {
    $('#auctionsThumbnails .auction_row').each(function() {
      let myAuction = $(this).attr('data-active');
      if (myAuction == 1) 
        $(this).show();
    });
  }
}

/**
 * Get number of pages necessary to all showing auctions.
 */
function getNumPagesNecessaryToVisibleAuctions() {
  let numAuctions = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    if ($(this).is(":visible")) 
      numAuctions++;
  });
  return Math.ceil(numAuctions/4.0);
}

/**
 * Set attribute data-page of each auction element.
 */
function setPagesOfVisibleAuctions() {
  let counter = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    if ($(this).is(":visible")) {
      let hisPage = Math.floor(counter/4)+1;
      $(this).attr('data-page', hisPage);
      counter++;
    }
    else {
      $(this).attr('data-page', -1);
    }
  });
}
