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
                        <a href="https://www.facebook.com/bootsnipp"><i id="social-fb" class="fa fa-facebook-square fa-3x social"></i></a>
                        <a href="https://twitter.com/bootsnipp"><i id="social-tw" class="fa fa-twitter-square fa-3x social"></i></a>
                        <a href="https://plus.google.com/+Bootsnipp-page"><i id="social-gp" class="fa fa-google-plus-square fa-3x social"></i></a>
                        <a href="mailto:bootsnipp@gmail.com"><i id="social-em" class="fa fa-envelope-square fa-3x social"></i></a>
                    </div>
                    <h4 class="text-center"><a href="#"><span class="glyphicon glyphicon-heart-empty" style="cursor:pointer;"></span> Add to watch list</a></h4>
                </div>

                <div class="col-md-8 col-xs-12 info">
                    <h3 class="hidden-xs">{$product.name}</h3>
                    <div class="sellerInfo">
                        <small>Auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}">{$seller.username}</a></small>
                        <div class="user-rating-stars">
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star-empty"></span>
                            <span class="glyphicon glyphicon-star-empty"></span>
                        </div>
                        <a class="hidden-xs">{$numReviews} Reviews</a>
                    </div>
                    <div class="col-md-6 text-center auctionDetails">
                        <h3 style="padding-top: 1em; padding-bottom: 0.5em;">Current Bid: {$auction.curr_bid}€</h3>
                        <div class="section">
                            <button class="btn btn-info" data-toggle="modal" data-target="#bidModal"> Bid</button>
                            <div class="modal modalLogin fade" id="bidModal" tabindex="-1" role="dialog">
                                <div class="modal-dialog1 modal-sm">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h4>Select the value of your bid!</h4>
                                        </div>

                                        <div class="row" style="margin: 10px; padding-top: 2em;">
                                            <div class="input-group number-spinner">
                            <span class="input-group-btn">
                              <button class="btn btn-default" data-dir="dwn"><span class="glyphicon glyphicon-minus"></span></button>
                            </span>
                                                <input type="text" class="form-control text-center" value="800$">
                                                <span class="input-group-btn">
					                    <button class="btn btn-default" data-dir="up"><span class="glyphicon glyphicon-plus"></span></button>
                        </span>
                                            </div>
                                        </div>

                                        <div class="modal-footer" style="padding-bottom: 0">
                                            <button type="submit" class="btn btn-info btn-default pull-right" data-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-info btn-default pull-left" data-dismiss="modal">Bid</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h3 class="time">02h:54m:10s</h3>
                        <h4>Ending date: Monday, Mar 6, 2017
                            4:12:50 AM WET</h4>

                        <div class="visitors">
                            <span class="pull-left"><i class="fa fa-lg fa-eye" aria-hidden="true"></i> 49 visitors</span>
                            <span class="pull-right"><i class="fa fa-lg fa-shopping-cart" aria-hidden="true"></i> {$numBidders} bidders</span>
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
                            <tbody>
                                {foreach $recentBidders as $recentBidder}
                                    <tr>
                                        <td class="col-xs-5"><a href="{$BASE_URL}pages/user/user.php?id={$recentBidder.id}">{$recentBidder.username}</a></td><td class="col-xs-2">57</td><td class="col-xs-5">{$recentBidder.date}</td>
                                    </tr>
                                {/foreach}
                            </tbody>
                        </table>
                    </div>
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
                                <strong class="col-md-2 col-xs-5">Watchers:</strong><p class="col-md-4"> </p>
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
                        <form class="newQuestion" action="javascript:void(0);">
                            <div class="form-group">
                                <label>Your Question</label>
                                <input type="hidden" name="auction-id" value="{$auction.id}">
                                <input type="hidden" name="token" value="{$token}">
                                <input type="hidden" name="user-id" value="{$userId}">
                                <textarea name="comment" class="form-control question-area" rows="3"></textarea>
                            </div>
                            <button type="submit" class="btn btn-default btn-send-question">Send</button>
                        </form>

                    <section class="comment-list">
                        {foreach $questions as $question}
                            <article class="row">
                                <div class="col-md-1 col-sm-1 hidden-xs">
                                    <figure class="thumbnail">
                                        <img class="img-responsive" src="{$BASE_URL}images/users/{$question.profile_pic}" />
                                    </figure>
                                </div>
                                <div class="col-md-10 col-sm-10 col-xs-12">
                                    <div class="panel panel-default arrow left">
                                        <div class="panel-body">
                                            <div class="media-heading">
                                                <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment">
                                                    <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                                                </button>
                                                <a href="{$BASE_URL}pages/user/user.php?id={$question.user_id}"><strong>{$question.user_username}</strong></a> {$question.date}
                                            </div>
                                            <div class="panel-collapse collapse in" id="collapseComment">
                                                <div class="media-body">
                                                    <p>{$question.message}</p>
                                                    <div class="comment-meta">
                                                        <span><a href="#">delete</a></span>
                                                        <span><a href="#">report</a></span>
                                                        <span><a href="#">hide</a></span>
                                                        <span><a href="#">reply</a></span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </article>
                            {if ($question.answer_message)}
                                <article class="row">
                                    <div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs">
                                        <figure class="thumbnail">
                                            <img class="img-responsive" src="{$BASE_URL}images/users/{$seller.profile_pic}"/>
                                        </figure>
                                    </div>
                                    <div class="col-md-9 col-sm-9 col-sm-offset-0 col-md-offset-0 col-xs-offset-1 col-xs-11">
                                        <div class="panel panel-default arrow left">
                                            <div class="panel-body">
                                                <div class="media-heading">
                                                    <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseReply">
                                                        <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                                                    </button>
                                                    <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}"><strong>{$seller.username}</strong></a>{$question.answer_date}
                                                </div>
                                                <div class="panel-collapse collapse in" id="collapseReply">
                                                    <div class="media-body">
                                                        <p>{$question.answer_message}</p>
                                                        <div class="comment-meta">
                                                            <span><a href="#">delete</a></span>
                                                            <span><a href="#">report</a></span>
                                                            <span><a href="#">hide</a></span>
                                                            <span><a href="#">reply</a></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </article>
                            {/if}
                        {/foreach}
                    </section>
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
<script src="{$BASE_URL}javascript/auction.js"></script>

{include file='common/footer.tpl'}