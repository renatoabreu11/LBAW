{foreach $auctions as $auction}
<div class="col-md-3 col-sm-6 col-xs-6 auction_row" data-page="{floor($auction@index/4+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" data-recentlyAdded="-{strtotime($auction.date_added)}" hidden>
  <span class="thumbnail text-center">

    <div class="dropdown">
      <a href="#" class="pull-right dropdown-toggle" data-toggle="dropdown">
        <i class="glyphicon glyphicon-chevron-down"></i>
      </a>
      <ul class="dropdown-menu dropdown-menu-right" style="margin-top: 15px;">
        <li class="dropdown-header">Auction</li>
        <li><a href="#">Remove auction</a></li>
        <li class="divider"></li>
        <li class="dropdown-header">Notifications</li>
        <li class="disabled"><a href="#">Disable notifications</a></li>
        <li><a href="#">Enable notifications</a></li>
      </ul>
    </div>
    <h4 style="height: 50px;">{$auction.product_name}</h4>
    <img src="https://www.thurrott.com/wp-content/uploads/2015/10/surface-book-hero.jpg" alt="...">
    <h4>Current bid: {$auction.curr_bid} €</h4>
    <div class="countdown">
        <h3 class="clock"><p hidden>{$auction.end_date}</p></h3>
    </div>
    <div class="row text-center" style="padding-top: 4px; padding-bottom: 10px;">
      <button class="btn btn-primary btn-sm"><a href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a></button>
    </div>
    <div class="seller">
      <p style="margin-bottom: 0px;">Product auctioned by <br><a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
      <span>
         {if ($auction.user_rating != null) }
           <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto; height: 17px;"></div>
         {else}
           <p style="height: 17px; margin: 0px;">Not rated.</p>
         {/if}
      </span>
    </div>
  </span>
</div>
{/foreach}