$(document).ready(function(){
    $('.slider1').bxSlider({
        slideWidth: 200,
        minSlides: 2,
        maxSlides: 4,
        slideMargin: 15
    });

    $(".btn-send-question").click(function() {
        var comment = $(".question-area").val();
        var auctionId = $("input[name=auction-id]").val();
        var token = $("input[name=token]").val();
        var userId = $("input[name=user-id]").val();

        console.info(comment + ", " + auctionId + ", " + token + ", " + userId);

        var request = $.ajax({
            type: 'POST',
            dataType: 'json',
            url: BASE_URL + 'api/auction/create_question.php',
            data: {
                "comment": comment,
                "auction-id": auctionId,
                "token": token,
                "user-id": userId
            },
            success: function(data) {
                console.log(data);
                if(data['error']) {
                    $.magnificPopup.open({
                        items: {
                            src: '<div class="white-popup">' + data['error'] + '</div>',
                            type: 'inline'
                        }
                    });
                } else {
                    $(".comment-list").prepend('<article class="row"> <div class="col-md-1 col-sm-1 hidden-xs"> <figure class="thumbnail"> <img class="img-responsive" src="{$BASE_URL}images/users/' + data['profile_pic'] + '" /> </figure> </div> <div class="col-md-10 col-sm-10 col-xs-12"> <div class="panel panel-default arrow left"> <div class="panel-body"> <div class="media-heading"> <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button> <a href="{$BASE_URL}pages/user/user.php?id=' + userId + '"><strong>' + data['username'] + '</strong></a> ' + data['date'] + ' </div> <div class="panel-collapse collapse in" id="collapseComment"> <div class="media-body"> <p>' + data['comment'] + '</p> <div class="comment-meta"> <span><a href="#">delete</a></span> <span><a href="#">report</a></span> <span><a href="#">hide</a></span> <span><a href="#">reply</a></span> </div> </div> </div> </div> </div> </div> </article>');
                }
            }
        });
    })
});
