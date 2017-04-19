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
            url  : '/api/authentication/signin.php',
            data : {
                "username": username,
                "password": password
            },
            datatype: "text"
        });

        // Callback handler that will be called on success
        request.done(function (response, textStatus, jqXHR){
            if(response === "Login Successful!"){
                location.reload(true);
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
});