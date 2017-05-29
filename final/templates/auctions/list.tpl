{if count($auctions) == 0}
  <div class="container-fluid" style="padding-top: 2em;">
    <div class="row-fluid">
      <div class="empty-content text-center">
        <i class="fa fa-frown-o fa-3x" aria-hidden="true"></i>
        <h3>There are no results that match your search</h3>
      </div>
    </div>
  </div>
{else}
  <div class="table-responsive">
    <table class="table table-hover collapse in" id="auctionsList">
      <tbody id="bodyToSort">
      {foreach $auctions as $auction}
        <tr class="auction_row" data-page="{floor($auction@index/8+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" hidden>
          <td class="image col-md-2"><img src="{$BASE_URL}images/auctions/thumbnails/{if $auction.image}{$auction.image}{else}default.jpeg{/if}" alt="Product image"></td>
          <td class="product_name product col-md-3">{$auction.product_name}<br></td>
          <td class="seller col-md-2">
            <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a>
            <div>
              {if ($auction.user_rating != null) }
                <br>
                <div class="rateYo text-center" data-rating="{$auction.user_rating}" style="margin: auto;"></div>
              {/if}
            </div>
          </td>
          <td class="price col-md-3">
            {if $auction.state == 'Created'}
              <small>Price: <strong>{$auction.start_bid}€</strong></small><br>
              <small>Starting date:</small><br>
              <strong style="font-size: 14px">{$auction.start_date_readable}</strong>
            {else}
              <small>Price: <strong>{$auction.curr_bid}€</strong></small><br>
              <small>Ends in</small>
              <div class="countdown">
                <div class="clock" style="font-weight: bolder; font-size: 14px;"><p hidden>{$auction.end_date}</p></div>
              </div>
            {/if}
          </td>
          <td class="watch col-md-2">
            <a class="btn btn-primary" href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a>
          </td>
        </tr>
      {/foreach}
      </tbody>
    </table>
  </div>
{/if}