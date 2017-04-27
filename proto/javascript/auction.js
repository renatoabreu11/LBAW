var token;
var userId;

$(document).ready(function(){
    token = $('input[name=token]').val();
    userId = $('input[name=user-id]').val();

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

    // Send answer.
    $(".btn-answer-question").click(function() {
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

    // Edit question.
    $(".edit-question").click(function() {
        var questionMessageHTML = $(this).parent().prev().children();
        var comment = questionMessageHTML.eq(0).text();
        var content = '<textarea name="updated-question" class="form-control answer-area" rows="3">' + comment + '</textarea><button type="submit" class="btn btn-default btn-edit-question">Send</button>';
        var questionId = $(this).closest("article").children().eq(0).val();

        questionMessageHTML.html(content);

        $(".btn-edit-question").click(function() {
            var editComment = $(this).prev().val();
            var questionMessageEditHTML = $(this).parent();

            var request = $.ajax({
                type: 'POST',
                url: BASE_URL + 'api/auction/question_edit.php',
                data: {
                    "question-id": questionId,
                    "comment": editComment,
                    "user-id": userId,
                    "token": token
                }
            });

            request.done(function (response, textStatus, jqXHR) {
                if(response.indexOf("success") >= 0) {
                    var editContent = '<p>' + editComment + '</p>';
                    questionMessageEditHTML.html(editContent);
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
    });

    $(".edit-answer").click(function() {
        var answerMessageHTML = $(this).parent().prev().children();
        var comment = answerMessageHTML.eq(0).text();
        var content = '<textarea name="updated-answer" class="form-control answer-area" rows="3">' + comment + '</textarea><button type="submit" class="btn btn-default btn-edit-answer">Send</button>';
        var answerId = $(this).closest("article").children().eq(0).val();

        answerMessageHTML.html(content);

        $(".btn-edit-answer").click(function() {
            var editComment = $(this).prev().val();
            var answerMessageEditHTML = $(this).parent();

            var request = $.ajax({
                type: 'POST',
                url: BASE_URL + 'api/auction/answer_edit.php',
                data: {
                    "answer-id": answerId,
                    "comment": editComment,
                    "user-id": userId,
                    "token": token
                }
            });

            request.done(function (response, textStatus, jqXHR) {
                if(response.indexOf("success") >= 0) {
                    var editContent = '<p>' + editComment + '</p>';
                    answerMessageEditHTML.html(editContent);
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
    });

    // Delete question.
    $(".delete-question").click(function() {
        var questionArticle = $(this).closest("article");
        var questionId = questionArticle.children().eq(0).val();
        var questionAnswerDiv = questionArticle.parent();

        var request = $.ajax({
            type: 'POST',
            url: BASE_URL + 'api/auction/question_delete.php',
            data: {
                "question-id": questionId,
                "user-id": userId,
                "token": token
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

    // Delete answer.
    $(".delete-answer").click(function() {
        var article = $(this).closest("article");
        var answerId = article.children().eq(0).val();

        var request = $.ajax({
            type: 'POST',
            url: BASE_URL + 'api/auction/answer_delete.php',
            data: {
                "answer-id": answerId,
                "user-id": userId,
                "token": token
            }
        });

        request.done(function (response, textStatus, jqXHR) {
            console.info(response);
            if(response.indexOf("success") >= 0) {
                article.fadeOut(500, function() { article.remove() });
            } else {
                $.magnificPopup.open({
                    items: {
                        src: '<div class="white-popup">' + response + '</div>',
                        type: 'inline'
                    }
                });
            }
        });
    });

    // Hides the reply box.
    $(".new-answer").toggle();

    // Reply (toggles reply form).
    $(".reply-question").click(function() {
        $(this).parent().next().toggle();
    });