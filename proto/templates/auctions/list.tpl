<table class="table table-hover collapse in" id="auctionsList">
  <tbody id="bodyToSort">
  {foreach $auctions as $auction}
    <tr class="auction_row" data-page="{floor($auction@index/8+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" hidden>
      <td class="image col-md-2"><img src="http://lorempixel.com/400/300/city/5" alt=""></td>
      <td id="product_name" class="product col-md-4">{$auction.product_name}<br></td>

      <!-- user rating -->
      <td class="seller col-md-2">
        <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a>
        <span>
        {if ($auction.user_rating != null) }
          <br>
          <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto;""></div>
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