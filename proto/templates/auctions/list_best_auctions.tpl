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
          <div class="col-lg-4 col-md-4 col-sm-4">
            {foreach $categories as $key => $category}
              {if ($key % 3 == 0) }
                 <a href="#">{$category.unnest}</a><br>
              {/if}
            {/foreach}
          </div>
          <div class="col-lg-4 col-md-4 col-sm-4">
            {foreach $categories as $key => $category}
              {if ($key % 3 == 1) }
                 <a href="#">{$category.unnest}</a><br>
              {/if}
            {/foreach}
          </div>
          <div class="col-lg-4 col-md-4 col-sm-4">
            {foreach $categories as $key => $category}
              {if ($key % 3 == 2) }
                 <a href="#">{$category.unnest}</a><br>
              {/if}
            {/foreach}
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

                {foreach $mostPopularAuctions as $auction}
                <tr>
                  <td class="image col-md-2"><img src="http://lorempixel.com/400/300/city/5" alt=""></td>
                  <td class="product col-md-4">{$auction.product_name}<br></td>

                  <!-- user rating -->
                  <td class="seller col-md-2">
                    <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a>
                    <span>
                    {if ($auction.user_rating != null) }
                      <br>
                      {for $var=2 to $auction.user_rating step 2}
                        <i class="fa fa-star"></i>
                      {/for} 
                      {if ($auction.user_rating % 2 == 1)}
                        <i class="fa fa-star-half-o"></i>
                        {for $var=$auction.user_rating+3 to 10 step 2}
                          <i class="fa fa-star-o"></i>
                        {/for} 
                      {else}
                        {for $var=$auction.user_rating+2 to 10 step 2}
                          <i class="fa fa-star-o"></i>
                        {/for}
                      {/if}
                    {/if}
                    </span>
                  </td>

                  <td class="price col-md-2">
                    <small>Current bid: {$auction.curr_bid} €</small>
                    <div class="countdown">
                      <span class="clock"><p hidden>{$auction.end_date}</p></span>
                    </div>
                  </td>
                  <td class="watch col-md-2">
                    <button class="btn btn-info"><a href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a></button>
                  </td>
                </tr>
                {/foreach}

                </tbody>
              </table>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}javascript/best_auctions.js"></script>


{include file='common/footer.tpl'}