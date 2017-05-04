$(document).ready(function() {
  setChangeListType();
  setCountdown();
  setSearchRequest();
  setPagination();
  setRankings();
  setSorting();
});

/**
 * Alternates between the view modes
 */
function setChangeListType() {
  $('#listType').find('.btn').click(function() {
    if(!$(this).hasClass('active')) {
      $(this).addClass('active');
      $(this).siblings().removeClass('active');
      let dataTarget = $(this).data('target');
      $(dataTarget).addClass('in');
      if(dataTarget === '#auctionsList')
        $('#auctionsThumbnails').removeClass('in');
      else if(dataTarget === '#auctionsThumbnails')
        $('#auctionsList').removeClass('in');
    }
  });
}

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
 * Set the search request given by the user,
 * and retrieves the necessary info accordingly
 */
function setSearchRequest() {
  $('#searchBtn').click(function() {
    let name = $('#inputSearch').val();
    let category = $('#category').find('option:selected').val();
    let fromPrice = $('#fromPrice').find('option:selected').val();
    let toPrice = $('#toPrice').find('option:selected').val();
    let fromTimeRem = $('#fromTimeRem').find('option:selected').val();
    let toTimeRem = $('#toTimeRem').find('option:selected').val();

    $.ajax({
      type: 'GET',
      url: BASE_URL + 'api/auctions/search_auctions.php',
      data: {
        'name': name,
        'category': category,
        'fromPrice': fromPrice,
        'toPrice': toPrice,
        'fromTimeRem': fromTimeRem,
        'toTimeRem': toTimeRem,
      },
      dataType: 'json',
      success: function(data) {
        $('#auctions').empty();
        $('#auctionsThumbnails').empty();
        $('#auctions').append(data['list']);
        $('#auctionsThumbnails').append(data['listThumbnail']);

        setCountdown();

        let nrPages = data['nr_pages'];
        $('#pagination').attr('data-nr_pages', nrPages);
        $('#pagination').twbsPagination('destroy');
        setPagination();
        setRankings();
        setSorting();
        $('#popular').trigger('click'); // update sort ordering
        $('#list_btn').trigger('click'); // update list type
      },
      error: function(data) {
        alert(data);
      },
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
 * Set sorting filters.
 */
function setSorting() {
  $('.auctionSort li').click(function() {
    $('.auctionSort li').removeClass('active');
    $(this).addClass('active');
    let id = this.id;

    showAllAuctions(); // tinysort dont sort hidden elements

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

    let page = $('#pagination').attr('data-curr_page');
    setAuctionsCurrPage();
    showAuctionsOfAPage(page);
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
 * Set attribute data-page of each auction element.
 */
function setAuctionsCurrPage() {
  let counter = 0;
  $('#auctions .auction_row').each(function() {
    let hisPage = Math.floor(counter/8)+1;
    $(this).attr('data-page', hisPage);
    counter++;
  });
  counter = 0;
  $('#auctionsThumbnails .auction_row').each(function() {
    let hisPage = Math.floor(counter/8)+1;
    $(this).attr('data-page', hisPage);
    counter++;
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

