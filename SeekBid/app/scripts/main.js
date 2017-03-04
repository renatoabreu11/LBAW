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

  /********************AuctionsPage.html****************/

  $("#listType .btn").click(function(){
    if(!$(this).hasClass("active")){
      $(this).addClass("active");
      $(this).siblings().removeClass("active");
      var dataTarget = $(this).data("target");
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

})();


