$(document).ready(function() {
  setCountdown();
  setPagination();
  setRankings();
  setSorting();
  setFilter();
  setRemoveAuctionFromWatchlist();
  setToogleNotifications();
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
        $(this).html('Offer expired!')
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
 * Set filter of auctions in watchlist
 */
function setFilter() {
  $('.selectpicker').on('change', function() {
    let selected = $(this).find('option:selected').val();

    $('#pagination').attr('data-nr_pages', 0);
    hideAllAuctions();
    showAuctionsSpecifiedInFilter(selected);

    let numPages = getNumPagesNecessaryToVisibleAuctions();
    $('#pagination').attr('data-nr_pages', numPages);
    setPagesOfVisibleAuctions();

    let currPage = 1;
    $('#pagination').attr('data-curr_page', currPage);
    $('#pagination').twbsPagination('destroy');
    setPagination();
  });
}

/**
 * Show auctions based on the selected option of filter.
 */
function showAuctionsSpecifiedInFilter(selected) {
  let auctions = $('#auctionsThumbnails').find('.auction_row');
  let noAuctions = true;
  if (selected == 'All auctions') {
    auctions.each(function() {
      noAuctions = false;
      $(this).show();
    });
  } else if (selected == 'My auctions') {
    auctions.each(function() {
      let myAuction = $(this).attr('data-myAuction');
      if (myAuction == 1) {
        noAuctions = false;
        $(this).show();
      }
    });
  } else if (selected == 'Closed auctions') {
    auctions.each(function() {
      let myAuction = $(this).attr('data-active');
      if (myAuction == 0) {
        noAuctions = false;
        $(this).show();
      }
    });
  } else if (selected == 'Open auctions') {
    auctions.each(function() {
      let myAuction = $(this).attr('data-active');
      if (myAuction == 1) {
        noAuctions = false;
        $(this).show();
      }
    });
  }

  if(noAuctions) {
    $('.noAvailableAuctions').show();
  }else{
    $('.noAvailableAuctions').hide();
  }
}

/**
 * Get number of pages necessary to all showing auctions.
 */
function getNumPagesNecessaryToVisibleAuctions() {
  let numAuctions = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    if ($(this).is(':visible'))
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
    if ($(this).is(':visible')) {
      let hisPage = Math.floor(counter/4)+1;
      $(this).attr('data-page', hisPage);
      counter++;
    } else {
      $(this).attr('data-page', -1);
    }
  });
}

/**
 * Set api call to remove an auction from watchlist.
 */
function setRemoveAuctionFromWatchlist() {
  $('.rm-auction').click(function() {
    let auctionId = $(this).closest('ul').attr('data-auctionId');
    let remLinkElem = $(this);

    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auctions/delete_auction_watchlist.php',
      data: {
        'token': token,
        'userId': userId,
        'auctionId': auctionId,
      },
      dataType: 'json',
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if(response.includes('Success')) {
          let auctionRow = remLinkElem.closest('.auction_row');
          auctionRow.fadeOut(500, function() {
            auctionRow.remove();

            let numPages = getNumPagesNecessaryToAllAuctions();
            let currPage = 1;
            $('#pagination').attr('data-nr_pages', numPages);
            $('#pagination').attr('data-curr_page', currPage);
            
            setPagesOfAuctions();
            if (getNumAuctions() == 0) {
              $('#pagination').twbsPagination('destroy');
              let selected = $(this).find('option:selected').val();
              showAuctionsSpecifiedInFilter(selected);
            }
            else {
              setPagination();
              showAuctionsOfAPage(currPage);
              setSorting();
              setFilter();
            }
          });
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

/**
 * Get number of pages necessary to all auctions.
 */
function getNumPagesNecessaryToAllAuctions() {
  let numAuctions = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    numAuctions++;
  });
  return Math.ceil(numAuctions/4.0);
}

/**
 * Get number of auctions.
 */
function getNumAuctions() {
  let numAuctions = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    numAuctions++;
  });
  return numAuctions;
}

/**
 * Set api call to toogle notification
 * option of one auction from watchlist.
 */
function setToogleNotifications() {
  $('.toogle-notif').click(function() {
    let auctionId = $(this).closest('ul').attr('data-auctionId');
    let liElem = $(this).closest('li');
    let ulElem = $(this).closest('ul');

    $.ajax({
      type: 'POST',
      url: BASE_URL + 'api/auctions/toogle_notifications.php',
      data: {
        'token': token,
        'userId': userId,
        'auctionId': auctionId,
      },
      dataType: 'json',
      success: function(data) {
        let message = data['message'];
        let response = data['response'];
        if(response.includes('Success')) {
          liElem.addClass('disabled');
          liElem.children('a').removeClass('toogle-notif');
          if (liElem.hasClass('disable-notif')) {
            ulElem.children('.enable-notif').addClass('toogle-notif');
            ulElem.children('.enable-notif').removeClass('disabled');
          } else {
            ulElem.children('.disable-notif').addClass('toogle-notif');
            ulElem.children('.disable-notif').removeClass('disabled');
          }
          setToogleNotifications();
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

