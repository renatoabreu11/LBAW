{include file = 'common/header.tpl'}

  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <ul class="breadcrumb">
          <li>
            <a href="#">Home</a> <span class="divider"></span>
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
          <img src="http://vignette3.wikia.nocookie.net/deadliestfiction/images/3/3c/Raiden_MGRR.jpg/revision/latest?cb=20121230200223" class="img-rounded center-block" alt="User avatar" width="156">
          <p class="text-center user-real-name">{$user.name}</p>
          <p class="text-center user-nick-name">{$user.username}</p>
          <p class="text-justify user-overview">{$user.short_bio}</p>
        </div>
        <hr>
        <div class="info-zone">
         <p><span class="glyphicon glyphicon-map-marker"></span>{$location.city}, {$location.country}</p>
          <p><span class="glyphicon glyphicon-envelope"></span><a href="mailto:{$user.email}"> {$user.email}</a></p>
          <p><span class="glyphicon glyphicon-phone"></span> {$user.phone}</p>
        </div>
        <hr>
        <div class="user-rating">
          <div class="user-rating-stars text-center">
            <span class="glyphicon glyphicon-star"></span>
            <span class="glyphicon glyphicon-star"></span>
            <span class="glyphicon glyphicon-star"></span>
            <span class="glyphicon glyphicon-star-empty"></span>
            <span class="glyphicon glyphicon-star-empty"></span>
          </div>
          <p class="user-rating-numeric text-center">{$user.rating}/10</p>
        </div>
        <hr>
        <button type="button" class="btn btn-primary btn-block">Follow</button>
      </div>

      <div class="col-sm-9">
        <ul class="nav nav-tabs">
          <li class="active"><a data-toggle="tab" href="#recent-activity">Recent Activity</a></li>
          <li><a data-toggle="tab" href="#details">Details</a></li>
          <li><a data-toggle="tab" href="#selling">Selling <span class="badge">{count($activeAuctions)}</span></a></li>
          <li><a data-toggle="tab" href="#reviews">Reviews <span class="badge">{count($reviews)}</span></a></li>
          <li><a data-toggle="tab" href="#wins">Wins <span class="badge">{count($wins)}</span></a></li>
          <li><a data-toggle="tab" href="#following">Following <span class="badge">{count($followingUsers)}</span></a></li>
        </ul>

        <div class="tab-content">

          <!-- ****************** Recent Activity ****************** -->
          <div id="recent-activity" class="tab-pane fade in active">
            {for $var=0 to 2 step 1}
              <div class="col-md-6">
                {if ($lastReviews[$var] != null)}
                  <div class="panel panel-default">
                    <div class="panel-heading">
                      <span class="recent-activity-type"><span class="glyphicon glyphicon-check"></span> Review</span>
                      <span class="recent-activity-date">{$lastReviews[$var].date}</span>
                    </div>
                    <div class="panel-body">
                      <p><a href="#">{$user.username}</a> wrote a review regarding an <a href="../../pages/auction/auction.php?id={$lastReviews[$var].auction_id}">auction</a> hosted by <a href="../../pages/user/user.php?id={$lastReviews[$var].seller_id}">{$lastReviews[$var].username}</a>.</p>
                    </div>
                  </div>
                {/if}
                {if ($lastBids[$var] != null)}
                  <div class="panel panel-default">
                    <div class="panel-heading">
                      <span class="recent-activity-type"><span class="glyphicon glyphicon-euro"></span> Bid</span>
                      <span class="recent-activity-date">{$lastBid[$var].date}</span>
                    </div>
                    <div class="panel-body">
                      <p><a href="#">{$user.username}</a> bid {$lastBid[$var].amount}€ on an <a href="../../pages/auction/auction.php?id={$lastBid[$var].auction_id}">auction</a> hosted by <a href="../../user/user.php?id={$lastBid[$var].seller_id}">{$lastBid[$var].seller_id}</a>.</p>
                    </div>
                  </div>
                {/if}
                {if ($lastFollowing[$var] != null)}
                  <div class="panel panel-default">
                    <div class="panel-heading">
                      <span class="recent-activity-type"><span class="glyphicon glyphicon-user"></span> Following</span>
                    </div>
                    <div class="panel-body">
                      <p class="recent-activity-type"><a href="#">{$user.username}</a> started to follow <a href="../../pages/user/user.php?id={$lastFollowing[$var].followed_id}">{$lastFollowing[$var].followed_username}</a>.</p>
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
                      <p><a href="#">{$user.username}</a> won an <a href="../../pages/auction/auction.php?id={$lastWins[$var].auction_id}">auction</a> hosted by <a href="#">{$lastWins[$var].username}</a>.</p>
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
                        <p><a href="#">{$user.username}</a> posted a question on an <a href="../../pages/auction/auction.php?id={$lastQuestions[$var].auction_id}">auction</a> hosted by <a href="#">{$lastQuestions[$var].seller_username}</a>.</p>
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
                      <p><a href="#">{$user.username}</a> added an <a href="../../pages/auction/auction.php?id={$lastWatchlistAuctions[0].id}">auction</a> to his <a href="#">watchlist</a>.</p>
                    </div>
                  </div>
                {/if}
              </div>
            {/for}
          </div>

          <!-- ****************** Details ****************** -->
          <div id="details" class="tab-pane fade">
            <p class="details-description">Who am I</p>
            <p class="details-description-info">{$user.full_bio}</p>
            <div class="details-short-info">
              <div class="col-md-6 col-xs-6">
                <span class="glyphicon glyphicon-home"></span>
                <p class="details-short-info-title">Member since</p>
                <p class="details-short-info-description">{$user.register_date}</p>
              </div>
              <div class="col-md-6 col-xs-6">
                <span class="glyphicon glyphicon-paperclip"></span>
                <p class="details-short-info-title">Total auctions</p>
                <p class="details-short-info-description"><a href="#">{$totalAuctions.number}</a></p>
              </div>
            </div>
          </div>

          <!-- ****************** Selling ****************** -->
          <div id="selling" class="tab-pane fade">
            <div class="selling-wrapper">
              <div class="table-responsive" id="auctions">
                <table class="table table-hover collapse in" id="auctionsList">
                  <tbody>
                  {foreach $activeAuctions as $auction}
                    <tr>
                      <td class="image col-md-2"><img src="../../images/products/{$auction.image}" alt="product image"></td>
                      <td class="product col-md-4">
                        <strong>{$auction.name}</strong><br>
                        {$auction.description}
                      </td>
                      <td class="seller col-md-2">
                        <a href="#">{$user.username}</a><br>
                        <span>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star"></i>
                          <i class="fa fa-star-half-o"></i>
                        </span>
                      </td>
                      <td class="price col-md-2">
                        <small>Current bid: ${$auction.curr_bid}</small>
                        <h5 class="time">{$auction.remaining_time}</h5>
                      </td>
                      <td class="watch col-md-2">
                        <button class="btn btn-info">Watch Auction</button>
                      </td>
                    </tr>
                  {/foreach}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          <!-- ****************** Reviews ****************** -->
          <div id="reviews" class="tab-pane fade">
            {foreach $reviews as $review}
              <div class="thumbnail review-item">
                <div class="row">
                  <div class="col-lg-3 col-md-3">
                    <a href="../../pages/auction/auction.php?id={$review.auction_id}"><img class="review-image" src="../../images/products/{$review.image_filename}"></a>
                    <div class="review-rating text-center">
                      <span class="glyphicon glyphicon-star"></span>
                      <span class="glyphicon glyphicon-star"></span>
                      <span class="glyphicon glyphicon-star"></span>
                      <span class="glyphicon glyphicon-star"></span>
                      <span class="glyphicon glyphicon-star-empty"></span>
                    </div>
                    <p class="text-center reviewer-info">By <a href="../../pages/user/user.php?id={$review.reviewer_id}">{$review.reviewer_username}</a> on {$review.date}</p>
                  </div>
                  <div class="col-md-9 col-sm-9">
                    <a href="#" class="review-product-name"><p>{$review.product_name}</p></a>
                    <hr class="title-comment-divider">
                    <p class="review-comment text-justify">{$review.message}</p>
                  </div>
                </div>
              </div>
            {/foreach}
          </div>

          <!-- ****************** Wins ****************** -->
          <div id="wins" class="tab-pane fade">
            {foreach $wins as $win}
              <div class="thumbnail win-item">
                <div class="row">
                  <div class="col-lg-3 col-md-3 win-wrapper">
                    <div id="win-info-image">
                      <a href="#"><img class="win-image img-rounded" src="http://www.nvidia.co.uk/content/EMEAI/images/geforce-refresh/mini-features/laptops-800m-graphics-cards.jpg" alt="Product image"></a>
                    </div>
                    <div id="win-info-text">
                      <div class="text-right win-info">
                        <span class="win-info-title">Base price: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.start_bid}€</button><br>
                        <span class="win-info-title">Bought price: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.curr_bid}€</button><br>
                        <span class="win-info-title">Date: </span><button type="button" class="btn btn-info btn-sm active win-info-value">{$win.end_date}</button><br>
                        <span class="win-info-title">Seller: </span><button type="button" class="btn btn-link btn-sm active win-info-value"><a href="#">{$win.seller_username}</a></button><br>
                      </div>
                    </div>
                  </div>
                  <div class="col-lg-9 col-md-9">
                    <a href="#" class="win-product-name"><p>{$win.product_name}</p></a>
                    <hr class="title-comment-divider">
                    <p class="win-comment text-justify">{$win.description}</p>
                    <hr>
                    <button type="button" data-toggle="collapse" data-target="#win-review-form" class="win-review-button-form btn btn-info btn-block">Review auction</button>
                    <form id="win-review-form" class="collapse">
                      <div class="win-review-rating">
                        <p class="win-review-rating-title">Rating: </p>
                        <div class="win-review-rating-stars">
                          <span class="glyphicon glyphicon-star-empty"></span>
                          <span class="glyphicon glyphicon-star-empty"></span>
                          <span class="glyphicon glyphicon-star-empty"></span>
                          <span class="glyphicon glyphicon-star-empty"></span>
                          <span class="glyphicon glyphicon-star-empty"></span>
                        </div>
                      </div>
                      <div class="win-review-question">
                        <p>Item as described by the seller? </p>
                        <label class="checkbox-inline"><input type="checkbox" value="yes">Yes</label>
                        <label class="checkbox-inline"><input type="checkbox" value="no">No</label>
                      </div>
                      <div class="win-review-question">
                        <p>Courteous service (if you contacted the seller)?</p>
                        <label class="checkbox-inline"><input type="checkbox" value="yes">Yes</label>
                        <label class="checkbox-inline"><input type="checkbox" value="no">No</label>
                        <label class="checkbox-inline"><input type="checkbox" value="null">Did not contact</label>
                      </div>
                      <div class="input-group win-review-comment">
                        <span class="input-group-addon"><i class="glyphicon glyphicon-comment"></i></span>
                        <textarea class="form-control" rows="3" columns="50" placeholder="Comment..."></textarea>
                      </div>
                      <button type="submit" class="btn btn-info btn-block" value="Submit">Submit</button>
                    </form>
                  </div>
                </div>
              </div>
            {/foreach}
          </div>

          <!-- ****************** Following ****************** -->
          <div id="following" class="tab-pane fade">
            {foreach $followingUsers as $followingUser}
              <div class="media">
                <div class="media-left">
                  <a href="../../pages/user/user.php?id={$followingUser.id}" class="media-object"><img class="media-object" src="{$followingUser.profile_pic}"></a>
                </div>
                <div class="media-body">
                  <a href="../../pages/user/user.php?id={$followingUser.id}" class="media-object"><p class="media-heading lead">{$followingUser.name}</p></a>
                  <a href="../../pages/user/user.php?id={$followingUser.id}" class="media-object"><p>{$followingUser.username}</p></a>
                </div>
                <div class="media-right">
                  <button type="button" class="btn btn-danger">Unfollow</button>
                </div>
              </div>
              <hr>
            {/foreach}
          </div>

        </div>
      </div>
    </div>
  </div>

{include file='common/footer.tpl'}