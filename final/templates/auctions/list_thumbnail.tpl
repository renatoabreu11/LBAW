{if count($auctions) == 0}
  <div class="container-fluid" style="padding-top: 2em;" hidden>
    <div class="row-fluid">
      <div class="empty-content text-center">
        <i class="fa fa-frown-o fa-3x" aria-hidden="true"></i>
        <h3>There are no results that match your search</h3>
      </div>
    </div>
  </div>
{else}
  {foreach $auctions as $auction}
    <div class="col-md-3 col-sm-6 col-xs-6 auction_row" data-page="{floor($auction@index/8+1)}" data-priceLow="{$auction.curr_bid}" data-priceHigh="-{$auction.curr_bid}" data-popular="-{$auction.numbids}" data-newest="-{strtotime($auction.start_date)}" data-ending="{strtotime($auction.end_date)}" hidden>
      <div class="thumbnail text-center">
        <div class="auctionTitleThumbnail">
          <h5>
            {$auction.product_name}
          </h5>
        </div>
        <img src="{$BASE_URL}images/auctions/thumbnails/{if $auction.image}{$auction.image}{else}default.jpeg{/if}" alt="Product image">
        {if $auction.state == 'Created'}
          <h4 style="height: 50px;">Initial price: <strong>{$auction.start_bid}€</strong></h4>
          <small>Starting date:</small><br>
          <strong style="margin-top: 0; font-size: 14px; height: 60px; display: flex; justify-content: center;align-items: center;">{$auction.start_date_readable}</strong>
        {else}
          <h4 style="height: 50px;">Current price: <strong>{$auction.curr_bid}€</strong></h4>
          <small>Ends in</small>
          <div class="countdown counterThumbnail">
            <div class="clock" style="font-weight: bolder; font-size: 14px;"><p hidden>{$auction.end_date}</p></div>
          </div>
        {/if}
        <div class="watchAuction" style="padding-top: 1em;">
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
{/if}