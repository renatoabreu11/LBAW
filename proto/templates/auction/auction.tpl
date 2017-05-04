




























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
            <ol class="carousel-indicators">
              <li data-target="#productGallery" data-slide-to="0" class="active"></li>
              <li data-target="#productGallery" data-slide-to="1"></li>
              <li data-target="#productGallery" data-slide-to="2"></li>
            </ol>

            <div class="carousel-inner" role="listbox">
              <div class="item active">
                <img src="https://images-na.ssl-images-amazon.com/images/I/81nmXFn%2BbDL._SL1500_.jpg" alt="Chania" width="460" height="345">
                <div class="carousel-caption">
                  <h3>Chania</h3>
                </div>
              </div>

              <div class="item">
                <img src="https://images-na.ssl-images-amazon.com/images/I/815UyQUdfoL._SL1500_.jpg" alt="Chania" width="460" height="345">
                <div class="carousel-caption">
                  <h3>Chania</h3>
                </div>
              </div>

              <div class="item">
                <img src="https://images-na.ssl-images-amazon.com/images/I/811PGIDq-RL._SL1500_.jpg" alt="Flower" width="460" height="345">
                <div class="carousel-caption">
                  <h3>Flowers</h3>
                </div>
              </div>
            </div>

            <a class="left carousel-control" href="#productGallery" role="button" data-slide="prev">
              <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
              <span class="sr-only">Previous</span>
            </a>
            <a class="right carousel-control" href="#productGallery" role="button" data-slide="next">
              <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
              <span class="sr-only">Next</span>
            </a>
          </div>
          <div class="share text-center">
            <a href=""><i id="social-fb" class="fa fa-facebook-square fa-3x social"></i></a>
            <!--<a href="https://twitter.com/bootsnipp"><i id="social-tw" class="fa fa-twitter-square fa-3x social"></i></a>
            <a href="https://plus.google.com/+Bootsnipp-page"><i id="social-gp" class="fa fa-google-plus-square fa-3x social"></i></a>
            <a href="mailto:bootsnipp@gmail.com"><i id="social-em" class="fa fa-envelope-square fa-3x social"></i></a>-->
          </div>
          <div class="sellerInfo text-center">
            <p style="margin-bottom: 2px;">Auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}">{$seller.username}</a></p>
            <p><a target="_blank" href="{$BASE_URL}pages/user/user.php?id={$seller.id}#reviews">{$numReviews} Review(s)</a></p>
            {if ($numReviews != 0)}<div class="rateYo text-center" data-rating="{$seller.rating}" style="margin: auto; margin-bottom: 5px;"></div>{/if}
          </div>
          {if ($USERNAME)}
          <div class="watchlist-button">
            {if ($isOnWatchlist)}
              <h4 class="text-center"><span class="glyphicon glyphicon-heart auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default btn-remove-auction-watchlist" style="border: none;">Remove from watch list</button></h4>
            {else}
              <h4 class="text-center"><span class="glyphicon glyphicon-heart-empty auction-watchlist-glyphicon" style="cursor:pointer;"></span> <button class="btn btn-default" data-toggle="modal" data-target="#watchlist-notification-modal" style="border: none;">Add to watch list</button></h4>
            {/if}
          </div>
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
        {/if}

      <div class="col-md-8 col-xs-12 info">
        <h3 class="hidden-xs">{$product.name}</h3>
        <hr style="margin-bottom: 0px;">
        <div class="col-md-6 text-center auctionDetails">
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
            <span class="clock"><p>{$auction.end_date}</p></span>
          </div>
          <h4>Ending date: {$auction.end_data_readable}</h4>

          <div class="visitors">
            <span><i class="fa fa-lg fa-shopping-cart" aria-hidden="true"></i> {$numBidders} bidders</span>
          </div>
        </div>
        <div class="col-md-6 bidders">
          <h4 style="padding-top: 1em;">Recent Bidders</h4>
          <table class="table table-fixed">
            <thead>
            <tr>
              <th class="col-xs-5">User</th><th class="col-xs-2">Bid</th><th class="col-xs-5">Date</th>
            </tr>
            </thead>
            <tbody class="bidders-table-body">
            {foreach $recentBidders as $recentBidder}
              <tr>
                <td class="col-xs-5"><a href="{$BASE_URL}pages/user/user.php?id={$recentBidder.id}">{$recentBidder.username}</a></td><td class="col-xs-2">{$recentBidder.amount}</td><td class="col-xs-5">{$recentBidder.date}</td>
              </tr>
            {/foreach}
            </tbody>
          </table>
          <span><a class="reportAuctionPopup btn btn-default pull-right" href="#reportAuctionConfirmation">Report</a></span>
        </div>
      </div>
    </div>

    <!-- Accessible information -->
    <input type="hidden" name="auction-id" value="{$auction.id}">
    <input type="hidden" name="user-username" value="{$username}">

    <div>
      <div id="reportAuctionConfirmation" class="white-popup mfp-hide">
        <form role="form" action="{$BASE_URL}api/admin/report_auction.php" method="post" id="reportAuctionForm">
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
            <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}"><h3 style="color: 	#5F9EA0">{$seller.username}</h3></a>
            <h4>Who am I</h4>
            {if ($seller.full_bio)}
              <p>{$seller.full_bio}</p>
            {else}
              <p>{$seller.short_bio}</p>
            {/if}
            <h4>Reliability</h4>
            <p>{$seller.username} has {$numReviews} reviews, and an average of <strong>{$seller.rating}</strong>/10 points.</p>
          </div>
        </div>
      </div>
    </div>

    <hr>

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

        <section id="qaSection" class="comment-list">
          {include file='auction/question.tpl'}
        </section>

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
            <form role="form" action="{$BASE_URL}api/admin/report_question.php" method="post" id="reportQuestionForm">
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
            <form role="form" action="{$BASE_URL}api/admin/report_answer.php" method="post" id="reportAnswerForm">
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

    {if (count($similarAuctions)) > 0}
      <div class="row suggestions">
        <div class='col-md-12 col-centered'>
          <h2>Similar Auctions</h2>
          <div class="slider1">
            {foreach $similarAuctions as $similarAuction}
              <div class="slide text-center">
                        <span>
                            <h4>{$similarAuction.name}</h4>
                            <img src="{$BASE_URL}pages/auction/auction.php?id={$similarAuction.id}" alt="...">
                            <button class="btn btn-info" style="margin: 0.5em;"><a href="{$BASE_URL}pages/auction/auction.php?id={$similarAuction.id}" style="color: white">Watch Auction</a></button>
                        </span>
              </div>
            {/foreach}
          </div>
        </div>
      </div>
    {/if}
  </div>
</div>
</div>

<script src="{$BASE_URL}lib/bxslider/jquery.bxslider.min.js"></script>
<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
<script src="{$BASE_URL}javascript/auction.js"></script>

{include file='common/footer.tpl'}