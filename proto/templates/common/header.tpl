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
    <link rel="stylesheet" href="{$BASE_URL}css/style.css">
    <link rel="stylesheet" href="{$BASE_URL}lib/dialog/bootstrap-dialog.min.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
    <script src="{$BASE_URL}lib/dialog/bootstrap-dialog.min.js"></script>
    <script src="{$BASE_URL}javascript/main.js"></script>
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
            {if !$ADMIN_USERNAME}
                <form class="navbar-form navbar-left">
                    <div class="form-group inner-addon left-addon">
                        <i class="glyphicon glyphicon-search"></i>
                        <input type="text" class="form-control" placeholder="Search">
                    </div>
                    <button type="submit" class="btn btn-default">Submit</button>
                </form>
            {/if}

            <ul class="nav navbar-nav navbar-right">
                {if !$USERNAME && !$ADMIN_USERNAME}
                    {include file='common/menu_logged_out.tpl'}
                {elseif $ADMIN_USERNAME}
                    <li>
                        <a href="#menu-toggle" id="menu-toggle" class="navlink">Admin Panel</a>
                    </li>
                {/if}

                {if $USERNAME || $ADMIN_USERNAME}
                    {include file='common/menu_logged_in.tpl'}
                {/if}
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
