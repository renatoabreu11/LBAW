{foreach $auctions as $auction}
	<div class="col-md-3 col-sm-6 col-xs-6">
  <span class="thumbnail text-center">
    <h4 style="height: 50px;">{$auction.product_name}</h4>
    <img src="https://www.thurrott.com/wp-content/uploads/2015/10/surface-book-hero.jpg" alt="...">
    <small>Current bid: {$auction.curr_bid} €</small>
    <div class="countdown" style="height: 50px;">
        <span class="clock"><p hidden>{$auction.end_date}</p></span>
    </div>
    <div class="watchAuction">
      <button class="btn btn-info btn-sm"><a href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a></button>
    </div>
    <div class="seller" style="height: 75px;">
      <p>Product auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
      <span>
         {if ($auction.user_rating != null) }
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
    </div>
  </span>
</div>
{/foreach}