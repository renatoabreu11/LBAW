<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="description" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  {if $isAuctionPage}
    <meta property="og:title" content="{$product.name}" />
    <meta property="og:description" content="{$product.description}" />
    <meta property="og:url" content="http://gnomo.fe.up.pt/~lbaw1662/final/pages/auction/auction.php?id={$auction.id}" />
    <meta property="og:image" content="http://gnomo.fe.up.pt/~lbaw1662/final/images/auctions/thumbnails/{$images[0]}" />
    <meta property="og:type" content="article" />
  {/if}
  {if $title}
    <title>{$title}</title>
  {else} <title>Seek Bid</title>
  {/if}

  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
  <link rel="stylesheet" href="{$BASE_URL}lib/magnific-popup/magnific-popup.css">

  {if $module == "Auction"}
    <link rel="stylesheet" href="{$BASE_URL}lib/bxslider/jquery.bxslider.min.css">
    <link rel="stylesheet" href="{$BASE_URL}lib/fileinput/fileinput.css">
    <link rel="stylesheet" href="{$BASE_URL}lib/datetimepicker/bootstrap-datetimepicker.css"/>
  {elseif $module == "Admin"}
    <link rel="stylesheet" href="{$BASE_URL}lib/datatables/dataTables.bootstrap.min.css">
  {elseif $module == "User"}
    <link rel="stylesheet" href="{$BASE_URL}lib/fileinput/fileinput.css">
  {elseif $module == "Auctions"}
    <link rel="stylesheet" href="{$BASE_URL}lib/datetimepicker/bootstrap-datetimepicker.css"/>
    <link rel="stylesheet" href="{$BASE_URL}lib/jqueryui/jquery-ui.min.css">
  {/if}
  <link rel="stylesheet" href="{$BASE_URL}lib/select/bootstrap-select.css">
  <link rel="stylesheet" href="{$BASE_URL}lib/star-rating/jquery.rateyo.min.css"/>
  <link rel="stylesheet" href="{$BASE_URL}css/style.min.css">

  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="https://cdn.jsdelivr.net/jquery.validation/1.16.0/jquery.validate.min.js"></script>
  <script src="{$BASE_URL}lib/magnific-popup/jquery.magnific-popup.js"></script>
  <script src="{$BASE_URL}javascript/main.min.js"></script>
</head>
<body>
<nav class="navbar navbar-default">
  <div class="container">
    <div class="navbar-header">
      <button class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="{$BASE_URL}index.php">Seek Bid</a>
    </div>
    <div class="collapse navbar-collapse" id="navbar-collapse-1">
      {if !$ADMIN_USERNAME}
        <div class="searchHeader">
          <form class="navbar-form navbar-left" action="{$BASE_URL}pages/auctions/auctions.php" method="get" role="search">
            <label class="sr-only" for="search">Search auctions</label>
            <div class="input-group">
              <input type="text" class="form-control" placeholder="Search auctions..." name="search" id="search">
              <div class="input-group-btn">
                <button class="btn btn-default"><span class="sr-only">Search </span><i class="glyphicon glyphicon-search"></i></button>
              </div>
            </div>
          </form>
        </div>
      {/if}
      <ul class="nav navbar-nav navbar-right">
        {if !$USERNAME && !$ADMIN_USERNAME}
          <li><a href="#" data-toggle="modal" data-target="#loginModal">Sign in</a></li>
          <li><a href="{$BASE_URL}pages/authentication/signup.php">Sign up</a></li>
        {elseif $ADMIN_USERNAME && $module == "Admin"}
          <li>
            <a href="#menu-toggle" id="menu-toggle" class="navlink">Admin Panel</a>
          </li>
        {/if}

        {if $USERNAME || $ADMIN_USERNAME}
          {include file='common/menu_logged_in.tpl'}
        {/if}
      </ul>
      {if !$USERNAME && !$ADMIN_USERNAME}
        {include file='authentication/signin.tpl'}
      {/if}
    </div>
  </div>
</nav>
{if (count($ERROR_MESSAGES) > 0)}
  <div class="row col-md-12">
    <div class="alert alert-danger fade in col-md-6 col-md-offset-3">
      <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
      <strong>Warning!</strong>
      {foreach $ERROR_MESSAGES as $error}
        <p>{$error}</p>
      {/foreach}
    </div>
  </div>
{/if}
{if (count($SUCCESS_MESSAGES) > 0)}
  <div class="row col-md-12">
    <div class="alert alert-success fade in col-md-6 col-md-offset-3">
      <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
      <strong>Success!</strong>
      {foreach $SUCCESS_MESSAGES as $success}
        <p>{$success}</p>
      {/foreach}
    </div>
  </div>
{/if}
{if $ADMIN_USERNAME}
  <input type="hidden" name="admin_id" value="{$ADMIN_ID}">
{elseif $USERNAME}
  <input type="hidden" name="user_id" value="{$USER_ID}">
{/if}
{if $USERNAME || $ADMIN_USERNAME}
  <input type="hidden" name="token" value="{$TOKEN}">
{/if}
