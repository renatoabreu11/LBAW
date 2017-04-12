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






{include file='common/footer.tpl'}