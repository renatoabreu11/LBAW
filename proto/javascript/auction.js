$(document).ready(function(){
    $('.slider1').bxSlider({
        slideWidth: 200,
        minSlides: 2,
        maxSlides: 4,
        slideMargin: 15
    });

    // Send question.
    $(".btn-send-question").click(function() {
        var comment = $(".question-area").val();
        var auctionId = $("input[name=auction-id]").val();
        var token = $("input[name=token]").val();
        var userId = $("input[name=user-id]").val();

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
                if(data['error']) {
                    $.magnificPopup.open({
                        items: {
                            src: '<div class="white-popup">' + data['error'] + '</div>',
                            type: 'inline'
                        }
                    });
                } else
                    var content = '<article class="row"> <div class="col-md-1 col-sm-1 hidden-xs"> <figure class="thumbnail"> <img class="img-responsive" src="' + BASE_URL + 'images/users/' + data['profile_pic'] + '" /> </figure> </div> <div class="col-md-10 col-sm-10 col-xs-12"> <div class="panel panel-default arrow left"> <div class="panel-body"> <div class="media-heading"> <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment"> <span class="glyphicon glyphicon-minus" aria-hidden="true"></span> </button> <a href="' + BASE_URL + ' pages/user/user.php?id=' + userId + '"><strong>' + data['username'] + '</strong></a> ' + data['date'] + ' </div> <div class="panel-collapse collapse in" id="collapseComment"> <div class="media-body"> <p>' + data['comment'] + '</p> <div class="comment-meta"> <span><a href="#">delete</a></span> <span><a href="#">report</a></span> <span><a href="#">hide</a></span> <span><a href="#">reply</a></span> </div> </div> </div> </div> </div> </div> </article>';
                    $(content).hide().appendTo(".comment-list").fadeIn(500);
            }
        });
    });

    // Delete question.
    $(".delete-question").click(function() {
        var userId = $("input[name=user-id]").val();
        var questionArticle = $(this).closest("article");
        var questionId = questionArticle.children().eq(0).val();
        var questionAnswerDiv = questionArticle.parent();

        var request = $.ajax({
            type: 'POST',
            url: BASE_URL + 'api/auction/question_delete.php',
            data: {
                "question-id": questionId,
                "user-id": userId
            }
        });

        request.done(function (response, textStatus, jqXHR) {
            if(response.indexOf("success") >= 0) {
                questionAnswerDiv.fadeOut(500, function() { questionAnswerDiv.remove(); });
            } else {
                $.magnificPopup.open({
                    items: {
                        src: '<div class="white-popup">' + response + '</div>',
                        type: 'inline'
                    }
                });
            }
        });

        request.fail(function (jqXHR, textStatus, errorThrown) {
            console.error("The following error occured: " + textStatus + ": " + errorThrown);
        });
    });

    // Hide question.
    $(".hide-question").click(function() {
        console.log("hiding");
    });

    // Hides the reply box.
    $(".new-answer").toggle();

    // Reply (toggles reply form).
    $(".reply-question").click(function() {
        $(this).parent().next().toggle();
    });

    // Send answer (here because we're referencing something just created above, the send button).
    $(".btn-answer-question").click(function() {
            var token = $('input[name=token]').val();
            var userId = $('input[name=user-id]').val();
            var comment = $(this).prev().children().eq(0).val();
            var questionArticle = $(this).closest("article");
            var questionId = questionArticle.children().eq(0).val();
            var replyBtn = $(this).parent().prev().children(".reply-question");;

            $.ajax({
                type: 'POST',
                url: BASE_URL + 'api/auction/create_answer.php',
                dataType: 'json',
                data: {
                    "token": token,
                    "user-id": userId,
                    "comment": comment,
                    "question-id": questionId
                },
                success: function(data) {
                    if(data['error']) {
                        $.magnificPopup.open({
                            items: {
                                src: '<div class="white-popup">' + data['error'] + '</div>',
                                type: 'inline'
                            }
                        });
                    } else {
                        var content = '<article class="row"><div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs"><figure class="thumbnail"><img class="img-responsive" src="' + BASE_URL + 'images/users/' + data['profile_pic'] + '"/></figure></div><div class="col-md-9 col-sm-9 col-sm-offset-0 col-md-offset-0 col-xs-offset-1 col-xs-11"><div class="panel panel-default arrow left"><div class="panel-body"><div class="media-heading"><button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseReply"><span class="glyphicon glyphicon-minus" aria-hidden="true"></span></button><a href="' + BASE_URL + 'pages/user/user.php?id=' + userId + '"><strong>' + data['username'] + '</strong></a>' + data['date'] + '</div><div class="panel-collapse collapse in" id="collapseReply"><div class="media-body"><p>' + comment + '</p><div class="comment-meta"><span><a href="#">delete</a></span><span><a href="#">report</a></span><span><a href="#">hide</a></span>                        </div>                    </div>                </div>            </div>        </div>    </div></article>';
                        $(content).hide().appendTo(questionArticle).fadeIn(500);
                        replyBtn.remove();
                    }
                }
            });
        });    
    });