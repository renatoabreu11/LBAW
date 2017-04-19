BASE_URL = '/';

$(document).ready(function() {
    $("#signinForm").validate({
        rules:
            {
                username: {
                    required: true,
                    maxlength: 32
                },
                password: {
                    required: true,
                    minlength: 8,
                    maxlength: 32
                }
            },
        messages:
            {
                username:{
                    required: "Please, enter your username.",
                    maxlength: "Your username must be no more than 32 characters."
                },
                password:{
                    required: "Please, enter your password.",
                    minlength: "Your password should be between 8 and 32 characters.",
                    maxlength: "Your password should be between 8 and 32 characters."
                }
            },
        errorPlacement: function(error, element) {
            error.insertAfter(element);
        },
        submitHandler: signin
    });

    function signin(){
        var form = $("#signinForm");
        var username = form.find("#usrname").val();
        var password = form.find("#psw").val();
        var request;
        request = $.ajax({
            type : 'POST',
            url  : BASE_URL + 'api/authentication/signin.php',
            data : {
                "username": username,
                "password": password
            },
            datatype: "text"
        });

        // Callback handler that will be called on success
        request.done(function (response, textStatus, jqXHR){
            if(response === "Login Successful!"){
                window.location.href=window.location.href;
            }else {
                $("#loginModal").find(".field_error").text(response);
            }
        });

        // Callback handler that will be called on failure
        request.fail(function (jqXHR, textStatus, errorThrown){
            console.error(
                "The following error occurred: "+
                textStatus, errorThrown
            );
        });
    }

    $(".leaveFeedbackPopup").on("click", function () {
        $('.leaveFeedbackPopup').magnificPopup({
            type:'inline',
            midClick: true
        }).magnificPopup('open');
    });

    $("#feedbackForm").validate({
        rules:{
            notification:{
                required: true,
                maxlength: 256
            }
        },
        submitHandler: leaveFeedback
    });

    function leaveFeedback() {
        $.magnificPopup.close();
        var username = $("#feedbackForm").find('input[name=username]').val();
        var feedback = $("#feedbackForm").find('input[name=feedback]').val();
        var request = $.ajax({
            type : 'POST',
            url  : BASE_URL + '/api/user/feedback.php',
            data : {
                "username": username,
                "feedback": feedback
            },
            datatype: "text"
        });

        // Callback handler that will be called on success
        request.done(function (response, textStatus, jqXHR){
            $.magnificPopup.open({
                items: {
                    src: '<div class="white-popup">' + response + '</div>',
                    type: 'inline'
                }
            });
            $("#feedbackForm").trigger("reset");
        });

        // Callback handler that will be called on failure
        request.fail(function (jqXHR, textStatus, errorThrown){
            console.error(
                "The following error occurred: "+
                textStatus, errorThrown
            );
        });
    }
});