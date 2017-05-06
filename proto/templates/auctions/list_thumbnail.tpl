{foreach $auctions as $auction}
<div class="col-md-3 col-sm-6 col-xs-6 auction_row" data-page="{floor($auction@index/8+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" hidden>
  <div class="thumbnail text-center">
  <h4 style="height: 50px;">{$auction.product_name}</h4>
  <img src="{$BASE_URL}images/products/{$auction.image}" alt="...">
  <small>Current bid: {$auction.curr_bid} €</small>
  <div class="countdown" style="height: 50px;">
      <div class="clock"><p hidden>{$auction.end_date}</p></div>
  </div>
  <div class="watchAuction">
    <a class="btn btn-info btn-sm" href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a>
  </div>
  <div class="seller" style="height: 75px;">
    <p>Product auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
    <div>
       {if ($auction.user_rating != null) }
         <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto;"></div>
       {/if}
    </div>
  </div>
</div>
</div>
{/foreach}