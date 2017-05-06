{include file='common/header.tpl'}

<div class="container">
  <div class="row">
    <div class="col-md-12">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li>
          <a href="#">Auctions</a> <span class="divider"></span>
        </li>
        <li class="active">
          Product
        </li>
      </ul>
    </div>
  </div>

  <div class="grid">
    <div class="grid-body">
      <div class="row auction">
        <h3 class="visible-xs" style="color: black;">{$product.name}</h3>
        <div class="col-md-4 col-xs-12">
          <div id="productGallery" class="carousel slide" data-ride="carousel">
            {if count($images) != 0}
              <ol class="carousel-indicators">
                {for $i = 0; $i < count($images); $i++}
                  {if $i == 0}
                    <li data-target="#productGallery" data-slide-to="{$i}" class="active"></li>
                  {else}
                    <li data-target="#productGallery" data-slide-to="{$i}"></li>
                  {/if}
                {/for}
              </ol>
            {/if}

            <div class="carousel-inner popup-gallery" role="listbox">
              {for $i = 0; $i < count($images); $i++}
              {if $i == 0}
              <div class="item active">
                {else}
                <div class="item">
                  {/if}
                  <a href="{$BASE_URL}images/auctions/{$images[$i].filename}" title="{$images[$i].description}">
                    <img src="{$BASE_URL}images/auctions/thumbnails/{$images[$i].filename}" alt="{$images[$i].description}">
                  </a>
                  <div class="carousel-caption">
                    <h5>{$images[$i].description}</h5>
                  </div>
                </div>
                {/for}
              </div>
              {if count($images) != 1}
                <a class="left carousel-control" href="#productGallery" role="button" data-slide="prev">
                  <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#productGallery" role="button" data-slide="next">
                  <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              {/if}
            </div>
            <h5 class="text-center" style="color: darkgray">Click on the image to expand it</h5>
            {if $USER_ID }
              <div class="share text-center" style="padding-bottom: 0.5em;">
                <a href="" class="btn btn-primary"><i id="social-fb" class="fa fa-facebook"> Share on facebook</i></a>
              </div>
            {/if}
            {if ($USER_ID) && $USER_ID != {$seller.id}}
              <div class="watchlist-button">
                {if ($isOnWatchlist)}
                  <h4 class="text-center"><span class="glyphicon glyphicon-heart auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default btn-remove-auction-watchlist" style="border: none;">Remove from watch list</button></h4>
                {else}
                  <h4 class="text-center"><span class="glyphicon glyphicon-heart-empty auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default" data-toggle="modal" data-target="#watchlist-notification-modal" style="border: none;">Add to watch list</button></h4>
                {/if}
              </div>
            {/if}
            {if ($USER_ID) && $USER_ID != {$seller.id}}
              <div class="text-center">
                <span><a class="reportAuctionPopup btn btn-default" href="#reportAuctionConfirmation">Report</a></span>
              </div>
            {/if}
            {if ($USER_ID) && $USER_ID == {$seller.id} && $canEdit}
              <div class="text-center">
                <span><a class="btn btn-default" href="{$BASE_URL}pages/auction/auction_edit.php?id={$auction.id}">Edit auction</a></span>
                <span><a class="btn btn-default" href="{$BASE_URL}pages/auction/auction_gallery.php?id={$auction.id}">Edit gallery</a></span>
                <span><a class="deleteAuctionPopup btn btn-default">Delete Auction</a></span>
              </div>
            {/if}
            <div id="watchlist-notification-modal" class="modal fade" role="dialog">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-body">
                    <p>Do you want to receive notifications regarding this auction?</p>
                    <button class="btn btn-primary btn-add-watchlist">No</button>
                    <button class="btn btn-primary btn-add-watchlist pull-right">Yes</button>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-8 col-xs-12 info">
            <h3 class="hidden-xs">{$product.name}</h3>
            <div class="sellerInfo">
              <span>Auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}">{$seller.username}</a></span>
              {if ($numReviews != 0)}
                <span class="rateYo user-rating-stars" data-rating="{$seller.rating}"></span>
              {/if}
              <span class="hidden-xs">
              <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}#reviews">{$numReviews} Review(s)</a>
            </span>
            </div>
            <div class="col-md-{if (count($recentBidders) > 0)}6{else}12{/if} text-center auctionDetails">
              <h3 style="padding-top: 1em; padding-bottom: 0.5em;" class="current-bid">Current Bid: {$auction.curr_bid}€</h3>
              {if ($seller.id != $USER_ID && $USER_ID && !$winningUser)}
                <div class="section">
                  <a class="btn btn-info binOnAuctionPopup" href="#bidOnAuction"> Bid</a>
                  <div id="bidOnAuction" class="white-popup mfp-hide">
                    <div class="row" style="margin: 10px;">
                      <h4 class="bid-title">Bid on auction</h4>
                      <div class="input-group number-spinner">
                        <span class="input-group-btn">
                            <button class="btn btn-default" data-dir="dwn"><span class="glyphicon glyphicon-minus"></span></button>
                        </span>
                        <input type="number" class="form-control text-center bid-amount" min={$auction.curr_bid + 0.01} value="{$auction.curr_bid+1}">
                        <span class="input-group-btn">
                            <button class="btn btn-default" data-dir="up"><span class="glyphicon glyphicon-plus"></span></button>
                        </span>
                      </div>
                    </div>
                    <div class="text-center">
                      <button class="btn btn-info bidOnAuction" style="width: 35%">Place bid</button>
                      <button class="btn btn-info closePopup" style="width: 35%">Close</button>
                    </div>
                  </div>
                </div>
              {/if}

              <div class="countdown">
                <div class="clock"><p>{$auction.end_date}</p></div>
              </div>
              <h4>Ending date: {$auction.end_data_readable}</h4>

              <div class="visitors">
                <span><i class="fa fa-lg fa-shopping-cart" aria-hidden="true"></i> {$numBidders} bidders</span>
              </div>
            </div>
            <div class="bidders">
              {include file='auction/list_bidders.tpl'}
            </div>
          </div>
        </div>
      </div>

    <!-- Accessible information -->
      <input type="hidden" name="auction-id" value="{$auction.id}">
      <input type="hidden" name="user-username" value="{$username}">
      <input type="hidden" name="seller" value="{$seller.username}">

      <div>
        <div id="reportAuctionConfirmation" class="white-popup mfp-hide">
          <form action="{$BASE_URL}api/admin/report_auction.php" method="post" id="reportAuctionForm">
            <div class="form-group">
              <label for="reportAuctionMessage">Report:</label>
              <textarea class="form-control" rows="5" id="reportAuctionMessage" name="reportAuctionMessage"></textarea>
            </div>
            <div class="text-center">
              <input type="submit" id="reportAuction" class="btn btn-info" value="Report Auction">
            </div>
          </form>
        </div>
      </div>

      <hr>

      <div class="row">
        <div class="col-md-12">
          <ul class="nav nav-tabs">
            <li class="active"><a data-toggle="tab" href="#product">Product Description</a></li>
            <li><a data-toggle="tab" href="#auctionInformation">Auction</a></li>
            <li><a data-toggle="tab" href="#seller">Seller</a></li>
          </ul>

          <div class="tab-content">
            <div id="product" class="tab-pane fade in active">
              <p>{$product.description}</p>
            </div>
            <div id="auctionInformation" class="tab-pane fade">
              <div class="row">
                <strong class="col-md-2 col-xs-5">Type of Auction:</strong><p class="col-md-4"> {$auction.type}</p>
                <strong class="col-md-2 col-xs-5">Fixed Price:</strong><p class="col-md-4"> {if ($auction.type == 'Dutch')}Yes{else}No{/if}</p>
              </div>
              <div class="row">
                <strong class="col-md-2 col-xs-5">Initial Price:</strong><p class="col-md-4"> {$auction.start_bid}€</p>
                <strong class="col-md-2 col-xs-5">Current Price:</strong><p class="col-md-4"> {$auction.curr_bid}€</p>
              </div>
              <div class="row">
                <strong class="col-md-2 col-xs-5">Starting Date:</strong><p class="col-md-4"> {$auction.start_date}</p>
                <strong class="col-md-2 col-xs-5">Ending Date:</strong><p class="col-md-4"> {$auction.end_date}</p>
              </div>
              <div class="row">
                <strong class="col-md-2 col-xs-5">Bids:</strong><p class="col-md-4"> {$numBids}</p>
                <strong class="col-md-2 col-xs-5">Winner:</strong><p class="col-md-4"> {if ($winningUser)}<a href="{$BASE_URL}pages/user/user.php?id={$winningUser.user_id}">{$winningUser.user_username}</a>{else}N/A{/if}</p>
              </div>
              <div class="row">
                <strong class="col-md-2 col-xs-5">Bidders:</strong><p class="col-md-4"> {$numBidders}</p>
                <strong class="col-md-2 col-xs-5">Category:</strong><p class="col-md-4"> </p>
              </div>
            </div>
            <div id="seller" class="tab-pane fade">
              <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}"><h3 >{$seller.username}</h3></a>
              {if ($seller.full_bio)}
                <p>{$seller.full_bio}</p>
              {else}
                <p>{$seller.short_bio}</p>
              {/if}
              <br>
              <p>{$seller.username} has {$numReviews} reviews, and an average of <strong>{$seller.rating}</strong>/10 points.</p>
            </div>
          </div>
        </div>
      </div>

      <hr>

      {if (($seller.id == $USER_ID && count($questions) > 0) || ($seller.id != $USER_ID && $USER_ID) || (!$USER_ID && count($questions) > 0))}
        <div class="row product-questions">
          <div class="col-md-12">
            <h2>Product Q&A</h2>
            {if ($seller.id != $USER_ID) && $USER_ID}
              <form id="newQuestionForm" action="{$BASE_URL}api/auction/create_question.php" method="post">
                <div class="form-group">
                  <label for="commentQuestion">Your question</label>
                  <textarea id="commentQuestion" name="comment" class="form-control question-area" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-default">Send</button>
              </form>
            {/if}

            <div id="qaSection" class="comment-list">
              {include file='auction/question.tpl'}
            </div>

            <div>
              <div id="removeQuestion" class="white-popup mfp-hide">
                <h4>Are you sure that you want to delete this answer?</h4>
                <p>You will not be able to undo this action!</p>
                <div class="text-center">
                  <button class="btn btn-info removeQuestion">Yes, I'm sure</button>
                  <button class="btn btn-info closePopup">No, go back</button>
                </div>
              </div>
            </div>

            <div>
              <div id="removeAnswer" class="white-popup mfp-hide">
                <h4>Are you sure that you want to delete this answer?</h4>
                <p>You will not be able to undo this action!</p>
                <div class="text-center">
                  <button class="btn btn-info removeAnswer">Yes, I'm sure</button>
                  <button class="btn btn-info closePopup">No, go back</button>
                </div>
              </div>
            </div>

            <div>
              <div id="reportQuestionConfirmation" class="white-popup mfp-hide">
                <form action="{$BASE_URL}api/admin/report_question.php" method="post" id="reportQuestionForm">
                  <div class="form-group">
                    <label for="reportQuestionMessage">Report:</label>
                    <textarea class="form-control" rows="5" id="reportQuestionMessage" name="reportQuestionMessage"></textarea>
                  </div>
                  <div class="text-center">
                    <input type="submit" id="reportQuestion" class="btn btn-info" value="Report question">
                  </div>
                </form>
              </div>
            </div>

            <div>
              <div id="reportAnswerConfirmation" class="white-popup mfp-hide">
                <form action="{$BASE_URL}api/admin/report_answer.php" method="post" id="reportAnswerForm">
                  <div class="form-group">
                    <label for="reportAnswerMessage">Report:</label>
                    <textarea class="form-control" rows="5" id="reportAnswerMessage" name="reportAnswerMessage"></textarea>
                  </div>
                  <div class="text-center">
                    <input type="submit" id="reportAnswer" class="btn btn-info" value="Report answer">
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
        <hr>
      {/if}

      {if (count($similarAuctions) > 0)}
        <div class="row suggestions">
          <div class='col-md-12 col-centered'>
            <h2>Similar Auctions</h2>
            <div class="slider1">
              {foreach $similarAuctions as $similarAuction}
                <div class="slide text-center">
                  <div>
                    <h4>{$similarAuction.name}</h4>
                    <img src="{$BASE_URL}pages/auction/auction.php?id={$similarAuction.id}" alt="...">
                    <span><a class="btn btn-info" href="{$BASE_URL}pages/auction/auction.php?id={$similarAuction.id}" style="color: white; margin: 0.5em;">Watch Auction</a></span>
                  </div>
                </div>
              {/foreach}
            </div>
          </div>
        </div>
      {/if}
    </div>
  </div>

    <script src="{$BASE_URL}lib/bxslider/jquery.bxslider.min.js"></script>
    <script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
    <script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
    <script src="{$BASE_URL}javascript/auction.js"></script>

{include file='common/footer.tpl'}