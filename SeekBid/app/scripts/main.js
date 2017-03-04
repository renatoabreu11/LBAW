(function() {
  'use strict';

  // Check to make sure service workers are supported in the current browser,
  // and that the current page is accessed from a secure origin. Using a
  // service worker from an insecure origin will trigger JS console errors. See
  // http://www.chromium.org/Home/chromium-security/prefer-secure-origins-for-powerful-new-features
  var isLocalhost = Boolean(window.location.hostname === 'localhost' ||
      // [::1] is the IPv6 localhost address.
      window.location.hostname === '[::1]' ||
      // 127.0.0.1/8 is considered localhost for IPv4.
      window.location.hostname.match(
        /^127(?:\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}$/
      )
    );

  if ('serviceWorker' in navigator &&
      (window.location.protocol === 'https:' || isLocalhost)) {
    navigator.serviceWorker.register('service-worker.js')
    .then(function(registration) {
      // updatefound is fired if service-worker.js changes.
      registration.onupdatefound = function() {
        // updatefound is also fired the very first time the SW is installed,
        // and there's no need to prompt for a reload at that point.
        // So check here to see if the page is already controlled,
        // i.e. whether there's an existing service worker.
        if (navigator.serviceWorker.controller) {
          // The updatefound event implies that registration.installing is set:
          // https://slightlyoff.github.io/ServiceWorker/spec/service_worker/index.html#service-worker-container-updatefound-event
          var installingWorker = registration.installing;

          installingWorker.onstatechange = function() {
            switch (installingWorker.state) {
              case 'installed':
                // At this point, the old content will have been purged and the
                // fresh content will have been added to the cache.
                // It's the perfect time to display a "New content is
                // available; please refresh." message in the page's interface.
                break;

              case 'redundant':
                throw new Error('The installing ' +
                                'service worker became redundant.');

              default:
                // Ignore
            }
          };
        }
      };
    }).catch(function(e) {
      console.error('Error during service worker registration:', e);
    });
  }

  /********************index.html****************/

  // Remove notification when clicking on the 'x' button.
  $(".dropdown .notifications-wrapper .notification-item-remove").click(function(e) {
    var notification = $(this).parent().parent().parent();
    notification.fadeOut(500, function() {
      notification.next().remove();   // Removes the associated divider.
      notification.remove();
    });

    if($(".notifications-wrapper").children().length == 1)
      $(".notifications-wrapper").html('<p class="notifications-empty">You have no new notifications</p>');
    else
      e.stopPropagation();    // Keeps the notification dropdown open.

  })

  // Remove notification once it's clicked (via link).
  $(".dropdown .notifications-wrapper .notification-item a").click(function() {
    var notification = $(this).parent().parent().parent();
    notification.next().remove();
    notification.remove();

    if($(".notifications-wrapper").children().length == 0)
      $(".notifications-wrapper").html('<p class="notifications-empty">You have no new notifications</p>');
  })

  // Remove all notifications.
  $(".dropdown .notification-footer a").click(function(e) {
    var notifications = $(".dropdown .notifications-wrapper").children();
    notifications.parent().html('<p class="notifications-empty">You have no new notifications</p>');
  })

  /********************AuctionsPage.html****************/

  $("#listType .btn").click(function(){
    if(!$(this).hasClass("active")){
      $(this).addClass("active");
      $(this).siblings().removeClass("active");
      var dataTarget = $(this).data("target");
      $(dataTarget).addClass("in");
      if(dataTarget == "#auctionsList")
        $("#auctionsThumbnails").removeClass("in");
      else if(dataTarget == "#auctionsThumbnails")
        $("#auctionsList").removeClass("in");
    }
  })

  /********************profile.html*****************/

  $("#wins .win-review-rating-stars .glyphicon").mouseover(function() {
    $(this).removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).prevAll().removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).nextAll().removeClass("glyphicon-star").addClass("glyphicon-star-empty");
  })


  /**************auction.html***************/

  $(document).on('click', '.number-spinner button', function () {
    var btn = $(this),
      oldValue = btn.closest('.number-spinner').find('input').val().trim(),
      newVal = 0;

    oldValue = oldValue.substring(0, oldValue.length-1);

    if (btn.attr('data-dir') == 'up') {
      newVal = parseInt(oldValue) + 1;
    } else {
      if (oldValue > 1) {
        newVal = parseInt(oldValue) - 1;
      } else {
        newVal = 1;
      }
    }
    btn.closest('.number-spinner').find('input').val(newVal+'$');
  });

  /****************admin.html*****************/

  $("#auctionsAdmin").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Auctions reports</strong></a>');
  });

  $("#usersAdmin").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Users reports</strong></a>');
  });

  $("#commentsAdmin").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Comments reports</strong></a>');
  });

  $("#reviewsAdmin").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Reviews reports</strong></a>');
  });

  $("#addCategory").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Add category</strong></a>');
  });

  $("#addAdmin").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Add admin</strong></a>');
  });

  $("#staffList").click(function() {
    $("#rightSide").html('<a href="#"><strong><i class="glyphicon glyphicon-dashboard"></i> Staff List</strong></a>');
  });

  /***************watchList.html***************/
  function updateClock() {

    var times = $(".time");
    for(var i = 0; i < times.length; i++){
      $(times[i]).text(decreaseTime_1second($(times[i]).text()));
    }

    // call this function again in 1000ms
    setTimeout(updateClock, 1000);
  };
  updateClock();

  // time format: "xxh:xxm:xxs"
  function decreaseTime_1second(time) {

    if (time.length != 11)
      return time;

    var hour = parseInt(time.substring(0, 2)),
        min = parseInt(time.substring(4, 6)),
        sec = parseInt(time.substring(8, 10));

    if (sec > 0) {
      sec--;
    }
    else if (min > 0) {
      min--; sec = 59;
    }
    else if (hour > 0) {
      hour--; min = 59; sec = 59;
    }

    if (hour < 10) hour = "0" + hour;
    if (min < 10) min = "0" + min;
    if (sec < 10) sec = "0" + sec;

    if (hour == 0 && min == 0 && sec == 0) return "Auction closed";
    else return hour + "h:" + min + "m:" + sec + "s";
  }

})();


