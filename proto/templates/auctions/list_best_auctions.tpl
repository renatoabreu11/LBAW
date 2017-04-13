{include file='common/header.tpl'}

<div class="container">

  <div class="col-lg-12 col-md-12">
    <div class="panel panel-info">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a href="#categories-wrapper" data-toggle="collapse">Categories</a>
        </h4>
      </div>
      <div id="categories-wrapper" class="panel-collapse collapse in">
        <div class="panel-body">
          <div class="col-lg-3 col-md-3 col-sm-3">
            <a href="#">Antiques</a><br>
            <a href="#">Art</a><br>
            <a href="#">Handcraft</a><br>
            <a href="#">Baby</a><br>
            <a href="#">Tickets and trips</a><br>
            <a href="#">Dolls and bears</a><br>
            <a href="#">Toys and hobbies</a><br>
            <a href="#">Cars and vehicles</a>
          </div>
          <div class="col-lg-3 col-md-3 col-sm-3">
            <a href="#">Sport souvenirs</a><br>
            <a href="#">Home and garden</a><br>
            <a href="#">Collectibles</a><br>
            <a href="#">Computers</a><br>
            <a href="#">Electronics</a><br>
            <a href="#">Spiritual</a><br>
            <a href="#">Movies and DVD's</a><br>
            <a href="#">Photos and optics</a>
          </div>
          <div class="col-lg-3 col-md-3 col-sm-3">
            <a href="#">Musical instruments</a><br>
            <a href="#">Jewells and watches</a><br>
            <a href="#">Charity auctions</a><br>
            <a href="#">Comics book and magazines</a><br>
            <a href="#">Bills and coins</a><br>
            <a href="#">Music and CD's</a><br>
            <a href="#">Office and industry</a><br>
            <a href="#">Seasonal occasions</a>
          </div>
          <div class="col-lg-3 col-md-3 col-sm-3">
            <a href="#">Pottery and ceramics</a><br>
            <a href="#">Sports products</a><br>
            <a href="#">Cloths and accessories</a><br>
            <a href="#">Health and beauty</a><br>
            <a href="#">Stamps</a><br>
            <a href="#">Video games</a>
          </div>
        </div>
      </div>
    </div>
  </div>

   <div class="col-lg-4 col-md-4 col-sm-4">

    <div class="item active">
        <span class="thumbnail text-center">
          <h4>Product Title</h4>
          <img src="http://placehold.it/256x256" class="animated bounce infinite" alt="...">
          <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
        </span>
    </div>

    <div class="text-center">
      <p class="index-info-title"><strong>Active auctions</strong></p>
      <p class="index-info-details">{$numActiveAuctions}</p>
    </div>

    <div class="text-center">
      <p class="index-info-title"><strong>Value of all the active auctions</strong></p>
      <p class="index-info-details">{$totalValOfActiveAuctions} €</p>
    </div>

    <table class="table table-hover table-best-users" style="margin-top: 60px;">
      <tbody>
      <tr>
        <td class="col-md-3">
          <p><strong>Rank</strong></p>
        </td>
        <td class="col-md-6">
          <p><strong>User</strong></p>
        </td>
        <td class="col-md-3">
          <p><strong>Review</strong></p>
        </td>
      </tr>

      {foreach $topTenRankingUsers as $key => $user}
      <tr>
        <td class="col-md-3">
          <p>{$key}</p>
        </td>
        <td class="col-md-6">
          <a href="#">{$user.username}</a>
        </td>
        <td class="col-md-3">
          <p>{$user.rating}/10</p>
        </td>
      </tr>
      {/foreach}

      </tbody>
    </table>
  </div>

  <div class="col-md-8">
    <div class="panel panel-primary">
      <div class="panel-heading" style="vertical-align: middle; padding-bottom: 2px;">
        <p><i class="fa fa-legal"></i> Hottest deals on Seek Bid!</p>
      </div>
      <div class="panel-body">
        <div class="gridIndex search">
          <div class="grid-body">
            <div class="row">
              <div class="col-sm-10 col-xs-12">
                <ul class="auctionSort">
                  <li class="active"><a href="#">Popular</a></li>
                  <li><a href="#">Newest</a></li>
                  <li><a href="#">Ending</a></li>
                  <li><a href="#">Price (low)</a></li>
                  <li><a href="#">Price (high)</a></li>
                </ul>
              </div>
            </div>

            <div class="table-responsive" id="auctions">
              <table class="table table-hover collapse in" id="auctionsList">
                <tbody>

                <tr>
                  <td class="image col-md-2"><img src="http://lorempixel.com/400/300/city/5" alt=""></td>
                  <td class="product col-md-4">
                    <strong>Product 1</strong><br>
                  </td>
                  <td class="seller col-md-2">
                    <a href="#">Gazorpazorpfield</a><br>
                    <span>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star"></i>
                    <i class="fa fa-star-half-o"></i>
                    </span>
                  </td>
                  <td class="price col-md-2">
                    <small>Current bid: $75,99</small>
                    <h5 class="time">02h:54m:10s</h5>
                  </td>
                  <td class="watch col-md-2">
                    <button class="btn btn-info">Watch Auction</button>
                  </td>
                </tr>

      





{include file='common/footer.tpl'}