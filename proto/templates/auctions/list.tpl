<table class="table table-hover collapse in" id="auctionsList">
  <tbody>
   {foreach $auctions as $auction}
    <tr class="auction_row" data-page="{floor($auction@index/8+1)}" hidden>
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
        <small>Current bid: <br>{$auction.curr_bid} €</small>
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