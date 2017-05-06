{include file='common/header.tpl'}

<div class="container">

  <div class="col-lg-12 col-md-12">
    <div class="panel panel-info">
      <div class="panel-heading">
        <h4 class="panel-title">
          <a href="#categories-wrapper" data-toggle="collapse">Categories</a>
        </h4>
      </div>
      <div id="categories-wrapper" class="panel-collapse collapse">
        <div class="panel-body">
          {foreach $categories as $category}
            <div class="col-lg-4 col-md-4 col-sm-4">
              <a href="{$BASE_URL}pages/auctions/auctions.php?category={urlencode($category.name)}">{$category.name}</a><br>
            </div>
          {/foreach}
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-4 col-md-4 col-sm-4">

    <div class="item active">
        <div class="thumbnail text-center">
          <h4>{$mostRecentAuction.product_name}</h4>
          <img src="{$BASE_URL}images/auctions/thumbnails/{$mostRecentAuction.image_filename}" class="animated bounce infinite" alt="Product image">
          <a class="btn btn-info" href="{$BASE_URL}pages/auction/auction.php?id={$mostRecentAuction.auction_id}" style="color: white;margin: 0.5em;">Watch Auction</a>
        </div>
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
            <p>{$key+1}</p>
          </td>
          <td class="col-md-6">
            <a href="{$BASE_URL}pages/user/user.php?id={$user.id}">{$user.username}</a>
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
                  <li id="popular" class="active"><a href="#">Popular</a></li>
                  <li id="newest"><a href="#">Newest</a></li>
                  <li id="ending"><a href="#">Ending</a></li>
                  <li id="priceLow"><a href="#">Price (low)</a></li>
                  <li id="priceHigh"><a href="#">Price (high)</a></li>
                </ul>
              </div>
            </div>

            <div class="table-responsive" id="auctions">
              {include file='auctions/list.tpl'}
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
<script src="{$BASE_URL}lib/tinysort/tinysort.js"></script>
<script src="{$BASE_URL}javascript/best_auctions.js"></script>

{include file='common/footer.tpl'}