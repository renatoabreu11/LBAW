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
                    $.magnificPopup.open({
                        items: {
                            src: '<div class="white-popup">' + data + '</div>',
                            type: 'inline'
                        }
                    });
                    form.trigger("reset");
                }
            },
            error: function(data){
                alert(data);
            }
        });
        return false;
    }

    var request;
    $("#newCategory").submit(function(event){
        // Prevent default posting of form - put here to work in case of errors
        event.preventDefault();

        // Abort any pending request
        if (request) {
            request.abort();
        }

        var form = $("#newCategory");
        var title = form.find("input[name='title']").val();

        request = $.ajax({
            type : 'POST',
            url  : '/api/admin/add_category.php',
            data : {
                "title": title
            },
            datatype: "text"
        });

        // Callback handler that will be called on success
        request.done(function (response, textStatus, jqXHR){
            if(response === "Category already exists"){
                form.find(".field_error").text(response);
            } else if(response === "Category successfully added!"){
                $.magnificPopup.open({
                    items: {
                        src: '<div class="white-popup">' + response + '</div>',
                        type: 'inline'
                    }
                });
                form.trigger("reset");
                var div = '<li class="list-group-item col-md-3">'+title+'</li>';
                $(".categories ul").append(div);
            }
        });

        // Callback handler that will be called on failure
        request.fail(function (jqXHR, textStatus, errorThrown){
            // Log the error to the console
            console.error(
                "The following error occurred: "+
                textStatus, errorThrown
            );
        });
    });

    var auctionTable = $('#auctionsTable');
    auctionTable.DataTable();
    var userTable = $('#usersTable');
    userTable.DataTable();
    var reportTable = $('#reportsTable');
    reportTable.DataTable();

    function deleteAuction(id) {
        var request;
        request = $.ajax({
            type : 'POST',
            url  : '/api/admin/remove_auction.php',
            data : {
                "id": id
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
            if(response === "Auction deleted!"){
                auctionTable.DataTable().row('.selected').remove().draw(false);
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

    function deleteUser(id) {
        var request;
        request = $.ajax({
            type : 'POST',
            url  : '/api/admin/remove_user.php',
            data : {
                "id": id
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
            if(response === "User deleted!"){
                userTable.DataTable().row('.selected').remove().draw(false);
            }
        });user

        // Callback handler that will be called on failure
        request.fail(function (jqXHR, textStatus, errorThrown){
            console.error(
                "The following error occurred: "+
                textStatus, errorThrown
            );
        });
    }

    function deleteReport(id, type) {
        var request;
        request = $.ajax({
            type : 'POST',
            url  : '/api/admin/remove_report.php',
            data : {
                "id": id,
                "type": type
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
            if(response === "Report deleted!"){
                reportTable.DataTable().row('.selected').remove().draw(false);
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

    $(".removePopup").on("click", function () {
        var row = auctionTable.find('tr.selected');
        var auction_id = row.find("td:first").html();
        if(auction_id === undefined)
            return;

        $('.removePopup').magnificPopup({
            type:'inline',
            midClick: true
        }).magnificPopup('open');

        $(".removeAuction").one("click", function () {
            $.magnificPopup.close();
            deleteAuction(auction_id);
        })
    });

    $(".removeUserPopup").on("click", function () {
        var row = userTable.find('tr.selected');
        var user_id = row.find("td:first").html();
        if(user_id === undefined)
            return;

        $('.removeUserPopup').magnificPopup({
            type:'inline',
            midClick: true
        }).magnificPopup('open');

        $(".removeUser").one("click", function () {
            $.magnificPopup.close();
            deleteUser(user_id);
        })
    });

    $(".notifyUserPopup").on("click", function () {
        var row = userTable.find('tr.selected');
        var user_id = row.find("td:first").html();
        if(user_id === undefined)
            return;

        $('.notifyUserPopup').magnificPopup({
            type:'inline',
            midClick: true
        }).magnificPopup('open');
    });

    $(".removeReportPopup").on("click", function () {
        var row = reportTable.find('tr.selected');
        var report_id = row.find("td:first").html();
        if(report_id === undefined)
            return;

        var report_type = reportTable.find('th.reportType').html();
        var types = ['Answer', 'Auction', 'User', 'Question', 'Review'];
        if(types.indexOf(report_type) === -1)
            return;

        $('.removeReportPopup').magnificPopup({
            type:'inline',
            midClick: true
        }).magnificPopup('open');

        $(".removeReport").one("click", function () {
            $.magnificPopup.close();
            deleteReport(report_id, report_type);
        })
    });

    $("#notificationForm").validate({
       rules:{
        notification:{
            required: true,
            maxlength: 256
        }
       },
        submitHandler: notifyUser
    });

    function notifyUser() {
        $.magnificPopup.close();
        var row = $('#usersTable').find('tr.selected');
        var id = row.find("td:first").html();
        var message = $("#notificationForm").find("textarea#notification").val();
        var request;
        request = $.ajax({
            type : 'POST',
            url  : '/api/admin/notify_user.php',
            data : {
                "id": id,
                "message": message
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
            $("#notificationForm").trigger("reset");
        });

        // Callback handler that will be called on failure
        request.fail(function (jqXHR, textStatus, errorThrown){
            console.error(
                "The following error occurred: "+
                textStatus, errorThrown
            );
        });
    }

    $(".closePopup").on("click", function () {
        $.magnificPopup.close();
    });

    auctionTable.find('tbody').on( 'click', 'tr', function () {
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }
        else {
            $('#auctionsTable').find('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    } );

    userTable.find('tbody').on( 'click', 'tr', function () {
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }
        else {
            $('#usersTable').find('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    } );

    reportTable.find('tbody').on( 'click', 'tr', function () {
        if ( $(this).hasClass('selected') ) {
            $(this).removeClass('selected');
        }
        else {
            $('#usersTable').find('tr.selected').removeClass('selected');
            $(this).addClass('selected');
        }
    } );
});
