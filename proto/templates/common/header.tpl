<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Seek Bid</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="/css/style.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    <script src="/javascript/main.js"></script>
</head>
<body>

<nav class="navbar navbar-default">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#">Seek Bid</a>
        </div>

        <div class="collapse navbar-collapse" id="navbar-collapse-1">
            <form class="navbar-form navbar-left">
                <div class="form-group inner-addon left-addon">
                    <i class="glyphicon glyphicon-search"></i>
                    <input type="text" class="form-control" placeholder="Search">
                </div>
                <button type="submit" class="btn btn-default">Submit</button>
            </form>

            <ul class="nav navbar-nav navbar-right">

                <li><a href="#" data-toggle="modal" data-target="#loginModal">Sign in</a></li>

                <div class="modal fade" id="loginModal" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                            <div class="modal-header">
                                <img src="/images/assets/favicon.jpg" class="img-rounded" alt="Cinque Terre" width="64" height="64">
                                <h4>Sign in to Seek Bid</h4>
                            </div>

                            <div class="modal-body">
                                <form role="form">
                                    <div class="form-group">
                                        <label for="usrname">Username or email address</label>
                                        <input type="text" class="form-control" id="usrname">
                                    </div>
                                    <div class="form-group">
                                        <label for="psw">Password</label>
                                        <input type="text" class="form-control" id="psw">
                                    </div>
                                    <div class="checkbox">
                                        <label><input type="checkbox" value="" checked>Remember me</label>
                                    </div>
                                    <button type="submit" class="btn btn-default btn-success btn-block">Sign in</button>
                                </form>
                            </div>

                            <div class="modal-footer">
                                <button type="submit" class="btn btn-default btn-default pull-left" data-dismiss="modal">Cancel</button>
                                <p>Not a member? <a href="#">Sign Up</a></p>
                            </div>
                        </div>
                    </div>
                </div>

                <li><a href="#">Sign up</a></li>
            </ul>
        </div>
    </div>
</nav>

<div id="error_messages">
    {foreach $ERROR_MESSAGES as $error}
        <div class="error">{$error}<a class="close" href="#">X</a></div>
    {/foreach}
</div>
<div id="success_messages">
    {foreach $SUCCESS_MESSAGES as $success}
        <div class="success">{$success}<a class="close" href="#">X</a></div>
    {/foreach}
</div>
