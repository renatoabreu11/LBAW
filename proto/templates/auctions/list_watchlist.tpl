{foreach $auctions as $auction}
<div class="col-md-3 col-sm-6 col-xs-6">
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
      <p>Product auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
      <span>
         {if ($auction.user_rating != null) }
           <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto;"></div>
         {/if}
      </span>
    </div>
  </span>
</div>
{/foreach}