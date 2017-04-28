$(document).ready(function() {
  setChangeListType();
  setCountdown();
  setSearchRequest();
  setPagination();
  setRankings();
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
      $('.auction_row').each(function() {
        let nrPage = parseInt($(this).attr('data-page'));
        if (nrPage == page)
          $(this).show();
        else
          $(this).hide();
      });

      window.scrollTo(0, 0);
    },
  });
}

/**
 * For each user, sets the star rating
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
