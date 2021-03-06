<div class="container-fluid noAvailableAuctions" style="padding-top: 1em;{if count($auctions) != 0} display:none;{/if}">
  <div class="row-fluid">
    <div class="empty-content text-center">
      <i class="fa fa-frown-o fa-3x" aria-hidden="true"></i>
      <h3>No available auctions in your watchlist</h3>
    </div>
  </div>
</div>
{foreach $auctions as $auction}
  <div class="col-md-3 col-sm-6 col-xs-6 auction_row" data-page="{floor($auction@index/4+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" data-recentlyAdded="-{strtotime($auction.date_added)}" data-myAuction="{$auction.myAuction}" data-active="{$auction.active}" hidden>
    <div class="thumbnail text-center">
      <div class="dropdown">
        <a href="javascript:void(0)" class="pull-right dropdown-toggle" data-toggle="dropdown">
          <span class="sr-only">Auction settings</span>
          <i class="glyphicon glyphicon-chevron-down"></i>
        </a>
        <ul class="dropdown-menu dropdown-menu-right" data-auctionId="{$auction.id}" style="margin-top: 15px;">
          <li class="dropdown-header">Auction</li>
          <li><a class="rm-auction" href="javascript:">Remove from watchlist</a></li>
          <li class="divider"></li>
          <li class="dropdown-header">Notifications</li>
          {if $auction.notifications }
            <li class="disable-notif"><a class="toogle-notif" href="javascript:">Disable notifications</a></li>
            <li class="enable-notif disabled"><a href="javascript:">Enable notifications</a></li>
          {else}
            <li class="disable-notif disabled"><a href="javascript:">Disable notifications</a></li>
            <li class="enable-notif"><a class="toogle-notif" href="javascript:">Enable notifications</a></li>
          {/if}
        </ul>
      </div>
      <div class="auctionTitleThumbnail">
        <h5>
          {$auction.product_name}
        </h5>
      </div>
      <img src="{$BASE_URL}images/auctions/thumbnails/{if ($auction.image)}{$auction.image}{else}default.jpeg{/if}" alt="Product image">
      {if $auction['state'] == 'Closed'}
        {if $auction.winner != NULL}
          <h4 style="height: 60px;">Auction won by
            <br>
            <a href="{$BASE_URL}pages/user/user.php?id={$auction.winner.id}"><strong style="font-size: 20px">{$auction.winner.username}</strong></a>
          </h4>
          <h4 class="current-bid" style="height: 60px;">Final bid: <strong style="font-size: 20px">{$auction.curr_bid}€</strong></h4>
        {else}
          <h4 class="current-bid" style="height: 60px;"><strong>Auction closed</strong></h4>
          <h4 style="height: 60px;">No one has bid on this auction.</h4>
        {/if}
      {elseif $auction['state'] == 'Open'}
        <h4 class="current-bid" style="height: 50px;">Current price: <strong>{$auction.curr_bid}€</strong></h4>
        <small>Ends in</small>
        <div class="countdown counterThumbnail">
          <div class="clock" style="font-weight: bolder; font-size: 20px;"><p hidden>{$auction.end_date}</p></div>
        </div>
      {elseif $auction['state'] == 'Created'}
        <h4 class="current-bid" style="height: 60px;">Initial price: <strong style="font-size: 20px">{$auction.curr_bid}€</strong></h4>
        <h4 style="height: 60px;">Offer starts <br><strong>{$auction.start_date_readable}</strong></h4>
      {/if}
      <div class="row text-center" style="padding-top: 4px; padding-bottom: 10px;">
        <a class="btn btn-primary btn-sm" href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a>
      </div>
      <div class="seller">
        <p style="margin-bottom: 0">Product auctioned by <br><a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
        <div>
          {if ($auction.user_rating != null) }
            <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto; height: 17px;"></div>
          {else}
            <p style="height: 17px; margin: 0">Not rated.</p>
          {/if}
        </div>
      </div>
    </div>
  </div>
{/foreach}
