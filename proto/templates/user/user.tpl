{include file = 'common/header.tpl'}

<div class="container">
  <div class="row">
    <div class="col-md-12">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li class="active">
          Profile
        </li>
      </ul>
    </div>
  </div>

  <div class="row">

    <!-- ****************** Left Information ****************** -->
    <div class="col-sm-3">
      <div class="info-name">
        <img src="{$profile_pic}" class="img-rounded center-block" alt="User Avatar" width="156">
        <p class="text-center user-real-name">{$user.name}</p>
        <p class="text-center user-nick-name">{$user.username}</p>
        <p class="text-justify user-overview">{$user.short_bio}</p>
      </div>
      <hr>
      <div class="info-zone">
        {if ($userCurrLocation)}
          <p><span class="glyphicon glyphicon-map-marker"></span>{$userCurrLocation.city_name}, {$userCurrLocation.country_name}</p>
        {/if}
        <p><span class="glyphicon glyphicon-envelope"></span><a href="mailto:{$user.email}"> {$user.email}</a></p>
        {if ($user.phone)}
          <p><span class="glyphicon glyphicon-phone"></span> {$user.phone}</p>
        {/if}
      </div>
      <hr>
      <div class="user-rating">
        {if ($totalAuctions != 0)}
          {if ($user.rating == null)}
            <p>No rating.</p>
          {else}
            <!--<br>-->
            <div class="rateYo" data-rating="{$user.rating}" style="margin: auto;"></div>
            <p class="user-rating-numeric text-center"><strong>{$user.rating}</strong>/10</p>
          {/if}
          <hr>
        {/if}
      </div>
      <div class="buttons-zone">
        {if ($USER_ID)}
          {if ($USER_ID != $user.id)}
            {if ($isFollowing.count == 0)}
              <button type="button" id="follow-btn" class="btn btn-primary btn-block">Follow</button>
            {else}
              <button type="button" id="follow-btn" class="btn btn-primary btn-block">Unfollow</button>
            {/if}
          {/if}
        {/if}

        {if ($USER_ID == $user.id)}
          <a href="{$BASE_URL}pages/user/user_edit.php?id={$user.id}" class="btn btn-info btn-block" role="button">Edit profile</a>
        {/if}
        {if !$ADMIN_ID && $USER_ID && $USER_ID != $user.id}
          <span><a class="reportUserPopup btn btn-primary btn-block" href="#reportUserConfirmation">Report</a></span>
        {/if}
      </div>
    </div>

    <div>
      <div id="reportUserConfirmation" class="white-popup mfp-hide">
        <form action="{$BASE_URL}api/admin/report_user.php" method="post" id="reportUserForm">
          <input type="hidden" name="reportedUserId" value="{$user.id}">
          <div class="form-group">
            <label for="reportUserMessage">Report:</label>
            <textarea class="form-control" rows="5" id="reportUserMessage" name="reportUserMessage"></textarea>
          </div>
          <div class="text-center">
            <input type="submit" id="reportUser" class="btn btn-info" value="Report user">
          </div>
        </form>
      </div>
    </div>

    <div class="col-sm-9">
      <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#recent-activity">Recent Activity</a></li>
        <li><a data-toggle="tab" href="#details">Details</a></li>
        {if ($totalAuctions > 0)} <li><a data-toggle="tab" href="#selling">Selling <span class="badge">{count($activeAuctions)}</span></a></li> {/if}
        {if ($totalAuctions > 0)} <li><a data-toggle="tab" href="#reviews">Reviews <span class="badge">{count($reviews)}</span></a></li> {/if}
        <li><a data-toggle="tab" href="#wins">Wins <span class="badge">{count($wins)}</span></a></li>
        <li><a data-toggle="tab" href="#following">Following <span class="badge following-badge">{count($followingUsers)}</span></a></li>
      </ul>

      <div class="tab-content">

        <!-- ****************** Recent Activity ****************** -->
        <div id="recent-activity" class="tab-pane fade in active">
          {if !($lastReviews || $lastBids || $lastFollowing || $lastWins || $lastQuestions || $lastWatchlistAuctions)}
            <p>No recent activities available.</p>
          {/if}
          {for $var=0 to 2 step 1}
            <div class="col-md-6">
              {if ($lastReviews[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-check"></span> Review</span>
                    <span class="recent-activity-date">{$lastReviews[$var].date}</span>
                  </div>
                  <div class="panel-body">
                    <p><a href="#">{$user.username}</a> wrote a review regarding an <a href="{$BASE_URL}pages/auction/auction.php?id={$lastReviews[$var].auction_id}">auction</a> hosted by <a href="{$BASE_URL}pages/user/user.php?id={$lastReviews[$var].seller_id}">{$lastReviews[$var].seller_username}</a>.</p>
                  </div>
                </div>
              {/if}
              {if ($lastBids[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-euro"></span> Bid</span>
                    <span class="recent-activity-date">{$lastBids[$var].date}</span>
                  </div>
                  <div class="panel-body">
                    <p><a href="#">{$user.username}</a> bid {$lastBids[$var].amount}€ on an <a href="{$BASE_URL}pages/auction/auction.php?id={$lastBids[$var].auction_id}">auction</a> hosted by <a href="{$BASE_URL}pages/user/user.php?id={$lastBids[$var].seller_id}">{$lastBids[$var].seller_username}</a>.</p>
                  </div>
                </div>
              {/if}
              {if ($lastFollowing[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-user"></span> Following</span>
                    <span class="recent-activity-date">{$lastFollowing[$var].date}</span>
                  </div>
                  <div class="panel-body">
                    <p class="recent-activity-type"><a href="#">{$user.username}</a> started to follow <a href="{$BASE_URL}pages/user/user.php?id={$lastFollowing[$var].followed_id}">{$lastFollowing[$var].followed_username}</a>.</p>
                  </div>
                </div>
              {/if}
              {if ($lastWins[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-shopping-cart"></span> Auction Won</span>
                    <span class="recent-activity-date">{$lastWins[$var].end_date}</span>
                  </div>
                  <div class="panel-body">
                    <p><a href="#">{$user.username}</a> won an <a href="{$BASE_URL}pages/auction/auction.php?id={$lastWins[$var].auction_id}">auction</a> hosted by <a href="{$BASE_URL}pages/user/user.php?id={$lastWins[$var].seller_id}">{$lastWins[$var].seller_username}</a>.</p>
                  </div>
                </div>
              {/if}
              {if ($lastQuestions[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-question-sign"></span> Question</span>
                    <span class="recent-activity-date">{$lastQuestions[$var].date}</span>
                  </div>
                  <div class="panel-body">
                    <p><a href="#">{$user.username}</a> posted a question on an <a href="{$BASE_URL}pages/auction/auction.php?id={$lastQuestions[$var].auction_id}">auction</a> hosted by <a href="#">{$lastQuestions[$var].seller_username}</a>.</p>
                  </div>
                </div>
              {/if}
              {if ($lastWatchlistAuctions[$var] != null)}
                <div class="panel panel-default">
                  <div class="panel-heading">
                    <span class="recent-activity-type"><span class="glyphicon glyphicon-eye-open"></span> Watchlist</span>
                    <span class="recent-activity-date">{$lastWatchlistAuctions[$var].date}</span>
                  </div>
                  <div class="panel-body">
                    <p><a href="#">{$user.username}</a> added an <a href="{$BASE_URL}pages/auction/auction.php?id={$lastWatchlistAuctions[$var].id}">auction</a> to his <a href="#">watchlist</a>.</p>
                  </div>
                </div>
              {/if}
            </div>
          {/for}
        </div>

        <!-- ****************** Details ****************** -->
        <div id="details" class="tab-pane fade">
          <p class="details-description">Who am I</p>
          {if ($user.full_bio != null)}
            <p class="details-description-info">{$user.full_bio}</p>
          {else}
            <p class="details-description-info">{$user.short_bio}</p>
          {/if}
          <div class="details-short-info">
            <div class="col-md-4 col-xs-4">
              <span class="glyphicon glyphicon-home"></span>
              <p class="details-short-info-title">Member since</p>
              <p class="details-short-info-member-since">{$user.register_date}</p>
            </div>
            <div class="col-md-4 col-xs-4">
              <span class="glyphicon glyphicon-user"></span>
              <p class="details-short-info-title">Member number</p>
              <p class="details-short-info-member-number">{$user.id}</p>
            </div>
            <div class="col-md-4 col-xs-4">
              <span class="glyphicon glyphicon-paperclip"></span>
              <p class="details-short-info-title">Total auctions</p>
              <p class="details-short-info-total-auctions">{$totalAuctions}</p>
            </div>
          </div>
        </div>

        <!-- ****************** Selling ****************** -->
        {if ($totalAuctions > 0)}
          <div id="selling" class="tab-pane fade">
            <div class="selling-wrapper">
              <div class="table-responsive" id="auctions">
                {if ($activeAuctions == null)}
                  <p>No active auctions currently available.</p>
                {else}
                  <table class="table table-hover collapse in" id="auctionsList">
                    <tbody>
                    {foreach $activeAuctions as $auction}
                      <tr>
                        <td class="image col-md-2"><img src="{$BASE_URL}images/products/{$auction.image}" alt="Product image"></td>
                        <td class="product col-md-6">
                          <strong>{$auction.name}</strong><br>
                          {$auction.description}
                        </td>
                        <td class="price col-md-2">
                          <small>Current bid: ${$auction.curr_bid}</small>
                          <h5 class="time">{$auction.remaining_time}</h5>
                        </td>
                        <td class="watch col-md-2">
                          <a class="btn btn-info" href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a>
                        </td>
                      </tr>
                    {/foreach}
                    </tbody>
                  </table>
                {/if}
              </div>
            </div>
          </div>
        {/if}

        <!-- ****************** Reviews ****************** -->
        {if ($totalAuctions > 0)}
          <div id="reviews" class="tab-pane fade">
            {if ($reviews == null)}
              <p>No reviews were written.</p>
            {else}
              {foreach $reviews as $review}
                <div class="thumbnail review-item">
                  <div class="row">
                    <div class="col-lg-3 col-md-3">
                      <a href="{$BASE_URL}pages/auction/auction.php?id={$review.auction_id}"><img class="review-image" src="{$BASE_URL}images/products/{$review.image_filename}" Alt="Product image"></a>
                      <div class="review-rating text-center">
                        <span class="glyphicon glyphicon-star"></span>
                        <span class="glyphicon glyphicon-star"></span>
                        <span class="glyphicon glyphicon-star"></span>
                        <span class="glyphicon glyphicon-star"></span>
                        <span class="glyphicon glyphicon-star-empty"></span>
                      </div>
                      <p class="text-center reviewer-info">By <a href="{$BASE_URL}pages/user/user.php?id={$review.reviewer_id}">{$review.reviewer_username}</a> on {$review.date}</p>
                    </div>
                    <div class="col-md-9 col-sm-9">
                      <a href="#" class="review-product-name"><p>{$review.product_name}</p></a>
                      <hr class="title-comment-divider">
                      <p class="review-comment text-justify">{$review.message}</p>
                    </div>
                  </div>
                </div>
              {/foreach}
            {/if}
          </div>
        {/if}

        <!-- ****************** Wins ****************** -->
        <div id="wins" class="tab-pane fade">
          {if ($wins == null)}
            <p>No auctions won.</p>
          {else}
            {foreach $wins as $win}
              <div class="thumbnail win-item">
                <div class="row">
                  <div class="col-lg-3 col-md-3 win-wrapper">
                    <div id="win-info-image">
                      <a href="{$BASE_URL}pages/auction/auction?id={$win.auction_id}"><img class="win-image img-rounded" src="{$BASE_URL}images/products/{$win.image_filename}" alt="Product image"></a>
                    </div>
                    <div id="win-info-text">
                      <div class="text-right win-info">
                        <span class="win-info-title">Base price: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.start_bid}€</button><br>
                        <span class="win-info-title">Bought price: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.curr_bid}€</button><br>
                        <span class="win-info-title">Date: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.end_date}</button><br>
                        <span class="win-info-title">Seller: </span><button type="button" class="btn btn-link btn-sm active win-info-value"><a href="{$BASE_URL}pages/user/user.php?id={$win.seller_id}">{$win.seller_username}</a></button><br>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-9 col-md-9">
                    <a href="#" class="win-product-name"><p>{$win.product_name}</p></a>
                    <hr class="title-comment-divider">
                    <p class="win-comment text-justify">{$win.description}</p>
                    <hr>
                    {if ($USER_ID == $user.id)}
                      {$isReviewed = false}
                      {foreach from=$reviewsPosted key=k item=a}
                        {if ($a.bid_id == $win.bid_id)}
                          {$isReviewed = true}
                        {/if}
                      {/foreach}
                      {if (!$isReviewed)}
                        <div class="form-wrapper">
                          <button type="button" data-toggle="collapse" data-target="#win-review-form" class="win-review-button-form btn btn-info btn-block">Review auction</button>
                          <form id="win-review-form" class="collapse" action="javascript:void(0);">
                            <input type="hidden" class="bid-id" value="{$win.bid_id}">
                            <div class="win-review-rating">
                              <p class="win-review-rating-title">Rating: </p>
                              <div class="win-review-rating-stars">
                                {for $var=0 to 9 step 1}
                                  <span class="glyphicon glyphicon-star-empty"></span>
                                {/for}
                              </div>
                            </div>
                            <div class="input-group win-review-comment">
                              <span class="input-group-addon"><i class="glyphicon glyphicon-comment"></i></span>
                              <textarea class="form-control" rows="3" columns="50" placeholder="Comment..."></textarea>
                            </div>
                            <button type="submit" class="btn btn-info btn-block btn-review-submit" value="Submit">Submit</button>
                          </form>
                        </div>
                      {/if}
                    {/if}

                  </div>
                </div>
              </div>
            {/foreach}
          {/if}
        </div>

        <!-- ****************** Following ****************** -->
        <div id="following" class="tab-pane fade">
          {if ($followingUsers == null)}
            <p>No users being followed.</p>
          {else}
            {foreach $followingUsers as $followingUser}
              <div class="media">
                <div class="media-left">
                  <a href="{$BASE_URL}pages/user/user.php?id={$followingUser.id}" class="media-object"><img class="media-object" src="{$BASE_URL}images/users/{$followingUser.profile_pic}" Alt="User photo"></a>
                </div>
                <div class="media-body">
                  <a href="{$BASE_URL}pages/user/user.php?id={$followingUser.id}" class="media-object"><p class="media-heading lead">{$followingUser.name}</p></a>
                  <a href="{$BASE_URL}pages/user/user.php?id={$followingUser.id}" class="media-object"><p>{$followingUser.username}</p></a>
                </div>
                {if ($USER_ID == $user.id)}
                  <div class="media-right">
                    <button type="button" class="btn btn-danger">Unfollow</button>
                  </div>
                {/if}
                <hr>
              </div>
            {/foreach}
          {/if}
        </div>

      </div>
    </div>
  </div>
</div>

<script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
<script type="text/javascript" src="{$BASE_URL}javascript/user.js"></script>

{include file='common/footer.tpl'}