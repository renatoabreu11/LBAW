$(document).ready(function(){
    $("#signupForm").validate({
        rules:
            {
                name: {
                    required: true,
                    maxlength: 64
                },
                username: {
                    required: true,
                    maxlength: 64
                },
                password: {
                    required: true,
                    minlength: 8,
                    maxlength: 64
                },
                confirm: {
                    required: true,
                    equalTo: $(this).find("#password")
                },
                email: {
                    email: true,
                    required: true
                },
                description: {
                    required: true,
                    maxlength: 255
                }
            },
        messages:
            {
                name:{
                    required: "Please, enter your name.",
                    maxlength: "Your name must be no more than 64 characters."
                },
                username:{
                    required: "Please, enter your username.",
                    maxlength: "Your username must be no more than 64 characters."
                },
                password:{
                    required: "Please, enter your password.",
                    minlength: "Your password should be between 8 and 64 characters.",
                    maxlength: "Your password should be between 8 and 64 characters."
                },
                confirm:{
                    required: "Please, enter your password.",
                    equalTo: "The confirmation password does not match."
                },
                email: "Please, enter your email.",
                description:{
                    required: "Please, enter your description.",
                    maxlength: "Your description must be no more than 255 characters."
                }
            },
        errorPlacement: function(error, element) {
            if($(element).attr("name") === "description")
                error.insertAfter(element);
            else{
                var parentDiv = $(element).parent(".input-group");
                error.insertAfter(parentDiv);
            }
        }
    });

    $("#adminSigninForm").validate({
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
        }
    });
});