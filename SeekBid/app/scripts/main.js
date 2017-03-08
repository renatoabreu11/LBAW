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

  //Update the notification badge number
  function updateNotificationBadge(numNotifications) {
    $(".dropdown .notification-badge").html(numNotifications);
  }

  // Remove notification when clicking on the 'x' button.
  $(".dropdown .notifications-wrapper .notification-item-remove").click(function(e) {
    var numNotifications = $(".notifications-wrapper").children().length;
    var notification = $(this).parent().parent();

    notification.fadeOut(500, function() {
      notification.remove();

      // To avoid setting to zero after 500 mls passed.
      if(numNotifications != 1)
        updateNotificationBadge(numNotifications-1);
    });

    if(numNotifications == 1) {
      $(".notifications-wrapper").html('<p class="notifications-empty">You have no new notifications</p>');
      updateNotificationBadge("");
    } else
      e.stopPropagation();    // Keeps the notification dropdown open.
  })

  // Remove notification once it's clicked (via link).
  $(".dropdown .notifications-wrapper .notification-media .notification-item-info").click(function() {
    var notification = $(this).parent().parent();
    notification.remove();

    var numNotifications = $(".notifications-wrapper").children().length;
    updateNotificationBadge(numNotifications);

    if(numNotifications == 0) {
      $(".notifications-wrapper").html('<p class="notifications-empty">You have no new notifications</p>');
      updateNotificationBadge("");
    }
  })

  // Remove notification once it's clicked (via image).
  $(".dropdown .notifications-wrapper .notification-media .notification-item-image").click(function() {
    var notification = $(this).parent().parent().parent();
    console.log(notification);
    notification.remove();

    var numNotifications = $(".notifications-wrapper").children().length;
    updateNotificationBadge(numNotifications);

    if(numNotifications == 0) {
      $(".notifications-wrapper").html('<p class="notifications-empty">You have no new notifications</p>');
      updateNotificationBadge("");
    }
  })

  // Remove all notifications.
  $(".dropdown .notification-footer a").click(function(e) {
    var notifications = $(".dropdown .notifications-wrapper").children();
    notifications.parent().html('<p class="notifications-empty">You have no new notifications</p>');
    updateNotificationBadge("");
  })

  //Collapses 'Categories' panel if in mobile.
  if($(window).width() <= 425)
    $("#categories-wrapper").removeClass('in');

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

  // Hovers stars to make a review.
  $("#wins .win-review-rating-stars .glyphicon").mouseover(function() {
    $(this).removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).prevAll().removeClass("glyphicon-star-empty").addClass("glyphicon-star");
    $(this).nextAll().removeClass("glyphicon-star").addClass("glyphicon-star-empty");
  })

  // Handles the 'Win' info when on hand devices.
  if($(window).width() <= 768) {
    $("#wins .win-info").removeClass("text-right").addClass("text-center");
    $("#wins .win-image").width(156);
  }

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

  $(".sidebar-nav li a").click(function(){
      var dataTarget = $(this).data("target");
      console.log(dataTarget)
      $(dataTarget).addClass("in");
      $(dataTarget).siblings(".collapse").removeClass("in");

      if(dataTarget == "#rightSideUsers" || dataTarget == "#rightSideAuctions" || dataTarget == "#rightSideComments" || dataTarget == "#rightSideReviews"){
        $(".box-body").show();
      } else $(".box-body").hide();
  });

  $("#menu-toggle").click(function(e) {
    e.preventDefault();
    $("#wrapper").toggleClass("toggled");
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

/* ==================== Create Auction ============================
 */

$(document).ready(function () {
  $('.slider1').bxSlider({
    slideWidth: 200,
    minSlides: 2,
    maxSlides: 4,
    slideMargin: 15
  });

  var navListItems = $('ul.setup-panel li a'), allWells = $('.setup-content');

  navListItems.click(function(e)
  {
    e.preventDefault();
    var $target = $($(this).attr('href')),
      $item = $(this).closest('li');

    if (!$item.hasClass('disabled')) {
      navListItems.closest('li').removeClass('active');
      $item.addClass('active');
      allWells.hide();
      $target.show();
    }
  });

  $('ul.setup-panel li.active a').trigger('click');

  $('#activate-step-2').on('click', function(e) {
    $('ul.setup-panel li:eq(1)').removeClass('disabled');
    $('ul.setup-panel li a[href="#step-2"]').trigger('click');
    $(this).remove();
  })

  $('#activate-step-3').on('click', function(e) {
    $('ul.setup-panel li:eq(2)').removeClass('disabled');
    $('ul.setup-panel li a[href="#step-3"]').trigger('click');
    $(this).remove();
  })
});
