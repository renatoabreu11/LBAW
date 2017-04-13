$(document).ready(function() {
    $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#wrapper").toggleClass("toggled");
    });

    $("#newAdmin").validate({
        rules:
            {
                email: {
                    email: true,
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
            },
        messages:
            {
                username:{
                    required: "Please, enter the admin's username.",
                    maxlength: "The admin's username must be no more than 64 characters."
                },
                password:{
                    required: "Please, enter the admin's password.",
                    minlength: "The admin's password should be between 8 and 64 characters.",
                    maxlength: "The admin's password should be between 8 and 64 characters."
                },
                confirm:{
                    required: "Please, enter the password confirmation.",
                    equalTo: "The confirmation password does not match."
                },
                email: {
                    email: "Please, enter the admin's email.",
                    maxlength: "The admin's email must be no more than 64 characters."
                }
            },
        errorPlacement: function(error, element) {
            var parentDiv = $(element).parent(".input-group");
            error.insertAfter(parentDiv);
        },
        submitHandler: addAdmin
    });

    function addAdmin() {
        var form = $("#newAdmin");
        var password = form.find("#password").val();
        var username = form.find("#username").val();
        var email = form.find("#email").val();
        var confirm = form.find("#confirm").val();
        $.ajax({
            type : 'POST',
            url  : '/api/admin/add_admin.php',
            data : {
                "username": username,
                "password": password,
                "email": email,
                "confirm": confirm
            },
            success: function(data){
                form.find(".field_error.username").text("");
                form.find(".field_error.email").text("");
                if(data === "Invalid username characters" || data === "Username already exists"){
                    form.find(".field_error.username").text(data);
                } else if(data === "Email already exists")
                    form.find(".field_error.email").text(data);
                else if(data === "Admin successfully added!"){
                    BootstrapDialog.show({
                        message: data
                    });
                    form.find("#password").val("");
                    form.find("#username").val("");
                    form.find("#email").val("");
                    form.find("#confirm").val("");
                }
            },
            error: function(data){
                alert(data);
            }
        });
        return false;

    }
});