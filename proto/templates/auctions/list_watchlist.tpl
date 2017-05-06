{foreach $auctions as $auction}
<div class="col-md-3 col-sm-6 col-xs-6 auction_row" data-page="{floor($auction@index/4+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" data-recentlyAdded="-{strtotime($auction.date_added)}" data-myAuction="{$auction.myAuction}" data-active="{$auction.active}" hidden>
  <div class="thumbnail text-center">

    <div class="dropdown">
      <a href="#" class="pull-right dropdown-toggle" data-toggle="dropdown">
        <i class="glyphicon glyphicon-chevron-down"></i>
      </a>
      <ul class="dropdown-menu dropdown-menu-right" data-auctionId="{$auction.id}" style="margin-top: 15px;">
        <li class="dropdown-header">Auction</li>
        <li><a class="rm-auction" href="javascript:;">Remove from watchlist</a></li>
        <li class="divider"></li>
        <li class="dropdown-header">Notifications</li>
        {if $auction.notifications }
        <li class="disable-notif"><a class="toogle-notif" href="javascript:;">Disable notifications</a></li> 
        <li class="enable-notif disabled"><a href="javascript:;">Enable notifications</a></li>  
        {else}
        <li class="disable-notif disabled"><a href="javascript:;">Disable notifications</a></li> 
        <li class="enable-notif"><a class="toogle-notif" href="javascript:;">Enable notifications</a></li> 
        {/if}
      </ul>
    </div>
    <h4 style="height: 50px;">{$auction.product_name}</h4>
    <img src="{$BASE_URL}images/auctions/thumbnails/{$auction.image}" alt="Image not available">
    <h4>Current bid: {$auction.curr_bid} €</h4>
    <div class="countdown">
        <h3 class="clock"><span hidden>{$auction.end_date}</span></h3>
    </div>
    <div class="row text-center" style="padding-top: 4px; padding-bottom: 10px;">
      <a class="btn btn-primary btn-sm" href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a>
    </div>
    <div class="seller">
      <p style="margin-bottom: 0px;">Product auctioned by <br><a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
      <div>
         {if ($auction.user_rating != null) }
           <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto; height: 17px;"></div>
         {else}
           <p style="height: 17px; margin: 0px;">Not rated.</p>
         {/if}
      </div>
    </div>
  </div>
</div>
{/foreach}