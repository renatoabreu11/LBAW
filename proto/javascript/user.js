$(document).ready(function() {

    // Handles the 'Win' info when on hand devices.
    if($(window).width() <= 768) {
        $("#wins .win-wrapper").removeClass("col-lg-3").removeClass("col-md-3");
        $("#wins .win-wrapper #win-info-image").addClass("col-sm-6");
        $("#wins .win-wrapper #win-info-text").addClass("col-sm-6");
        $("#wins .win-info").removeClass("text-right").addClass("text-center");
        $("#wins .win-image").width(156);
    };

    // Follow/Unfollow button (below the basic details).
    $("#follow-btn").click(function() {
        var userId = $("#details .details-short-info-member-number").text();
        var btnText = $(this).text();

        if(btnText == "Follow") {
            var request = $.ajax({
                type: 'POST',
                url: '/api/user/follow.php',
                data: {
                    "followedUserId": userId
                }
            });

            request.done(function (response, textStatus, jqXHR) {
                console.info("Response: " + response);
                if(response.indexOf("success") >= 0)
                    $("#follow-btn").html('Unfollow');
            });

            request.fail(function (jqXHR, textStatus, errorThrown) {
                console.error("The following error occured: " + textStatus + ": " + errorThrown);
            });
        } else {
            var request = $.ajax({
                type: 'POST',
                url: '/api/user/unfollow.php',
                data: {
                    "followedUserId": userId
                }
            });

            request.done(function (response, textStatus, jqXHR) {
                console.info("Response: " + response);
                if(response.indexOf("success") >= 0)
                    $("#follow-btn").html('Follow');
            });

            request.fail(function (jqXHR, textStatus, errorThrown) {
                console.error("The following error occured: " + textStatus + ": " + errorThrown);
            });
        }
    });

    // Unfollow button (using tabs).
    $("#following .btn").click(function() {
        var followedUserId = 2;        // Change. get attr href (id).
        var mediaObj = $(this).parent().parent();

        var request = $.ajax({
            type: 'POST',
            url: '/api/user/unfollow.php',
            data: {
                "followedUserId": followedUserId
            }
        });

        request.done(function (response, textStatus, jqXHR) {
            console.info("Response: " + response);
            if(response.indexOf("success") >= 0) {
                mediaObj.fadeOut(500, function() {
                    mediaObj.remove(); 

                    // Updates badge number.
                    var currBadgeNum = $(".following-badge").html();
                    $(".following-badge").html(parseInt(currBadgeNum, 10)-1);

                    // If there's no more followed users, changes html.
                    var followingDiv = $("#following");
                    if(followingDiv.children().length == 0)
                        followingDiv.html('<p>No users being followed.</p>');
                });
            }
        });

        request.fail(function (jqXHR, textStatus, errorThrown) {
            console.error("The following error occured: " + textStatus + ": " + errorThrown);
        });
    });

    /**
     * Review auction
     */
    // Hovers stars to make a review.
    $("#wins .win-review-rating-stars .glyphicon").mouseover(function() {
        $(this).removeClass("glyphicon-star-empty").addClass("glyphicon-star");
        $(this).prevAll().removeClass("glyphicon-star-empty").addClass("glyphicon-star");
        $(this).nextAll().removeClass("glyphicon-star").addClass("glyphicon-star-empty");
    });

    // Review submit button.
    $(".btn-review-submit").click(function() {
        var rating = $(this).prev().prev().children(".win-review-rating-stars").children(".glyphicon-star").length;
        var message = $(this).prev().children("textarea").val();
        var bidId = $(this).prev().prev().prev().val();
        var formWrapper = $(this).parent().parent();

        var request = $.ajax({
            type: 'POST',
            url: '/api/user/review_auction.php',
            data: {
                "rating": rating,
                "message": message,
                "bid_id": bidId
            }
        });

        request.done(function (response, textStatus, jqXHR) {
            console.info("Insert review response: " + response);
            if(response.indexOf("success") >= 0) {
                // Removes the form wrapper.
                formWrapper.fadeOut(500, function() { formWrapper.remove() });
            }
        });

        request.fail(function (jqXHR, textStatus, errorThrown) {
            console.error("The following error occured: " + textStatus + ": " + errorThrown);
        });
    });
});