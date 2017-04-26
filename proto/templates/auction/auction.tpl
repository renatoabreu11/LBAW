{include file='common/header.tpl'}

<div class="container">
    <div class="row">
        <div class="col-md-12">
            <ul class="breadcrumb">
                <li>
                    <a href="#">Home</a> <span class="divider"></span>
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
                    <h5 class="text-center" style="color: darkgray">Click on the image to expand it</h5>
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
                        <small>Auctioned by <a href="#">CYBERPOWERPC</a></small>
                        <div class="user-rating-stars">
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star"></span>
                            <span class="glyphicon glyphicon-star-empty"></span>
                            <span class="glyphicon glyphicon-star-empty"></span>
                        </div>
                        <a class="hidden-xs">12 Reviews</a>
                    </div>
                    <div class="col-md-6 text-center auctionDetails">
                        <h3 style="padding-top: 1em; padding-bottom: 0.5em;">Current Bid: $799</h3>
                        <div class="section">
                            <button class="btn btn-info" data-toggle="modal" data-target="#bidModal"> Bid</button>
                            <div class="modalLogin fade" id="bidModal" tabindex="-1" role="dialog">
                                <div class="modal-dialog modal-sm">
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
                            <span class="pull-right"><i class="fa fa-lg fa-shopping-cart" aria-hidden="true"></i> 87 bidders</span>
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
                            <tr>
                                <td class="col-xs-5"><a href="#">Mike Adams</a></td><td class="col-xs-2">57</td><td class="col-xs-5">12:10 17/10/17</td>
                            </tr>
                            <tr>
                                <td class="col-xs-5"><a href="#">Mike Adams</a></td><td class="col-xs-2">57</td><td class="col-xs-5">12:10 17/10/17</td>
                            </tr>
                            <tr>
                                <td class="col-xs-5"><a href="#">Mike Adams</a></td><td class="col-xs-2">57</td><td class="col-xs-5">12:10 17/10/17</td>
                            </tr>
                            <tr>
                                <td class="col-xs-5"><a href="#">Mike Adams</a></td><td class="col-xs-2">57</td><td class="col-xs-5">12:10 17/10/17</td>
                            </tr>
                            <tr>
                                <td class="col-xs-5"><a href="#">Mike Adams</a></td><td class="col-xs-2">57</td><td class="col-xs-5">12:10 17/10/17</td>
                            </tr>
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
                            <p>The CyberPowerPC Gamer Xtreme VR is optimized for gaming, and is also VR ready. The Intel CPU and High Performance GPU gives the computer the raw power it needs to function at a high level. Added on, the high speed memory and large hard drive gives the CyberPowerPC Gamer Xtreme VR all the space needed to only focus on gaming.</p>
                            <h4>Specifications</h4>
                            <ul>
                                <li>
                                    System: Intel i5-6402P 2.8GHz Quad-Core | Intel B150 Chipset | 8GB DDR4 | 1TB HDD | WI-FI USB Adapter | Genuine Windows 10 Home 64-bit
                                </li>
                                <li>
                                    Graphics: AMD Radeon RX 480 4GB Video Card | VR Ready | 1x HDMI | 1x Display Port
                                </li>
                                <li>
                                    Connectivity: 6 x USB 3.0 | 4 x USB 2.0 | 1x RJ-45 Network Ethernet 10/100/1000 | Audio: 7.1 Channel Keyboard and Mouse
                                </li>
                                <li>
                                    Warranty: 1 Year Parts & Labor Warranty Free Lifetime Tech Support"
                                </li>
                            </ul>
                            <h4>Condition</h4>
                            <p>
                                An item that has been used previously. The item may have some signs of cosmetic wear, but is fully operational and functions as intended. This item may be a floor model or store return that has been used.</p>
                        </div>
                        <div id="auctionInformation" class="tab-pane fade">
                            <div class="row">
                                <strong class="col-md-2 col-xs-5">Type of Auction:</strong><p class="col-md-4"> Sealed Bid</p>
                                <strong class="col-md-2 col-xs-5">Fixed Price:</strong><p class="col-md-4"> No</p>
                            </div>
                            <div class="row">
                                <strong class="col-md-2 col-xs-5">Initial Price:</strong><p class="col-md-4"> 157€</p>
                                <strong class="col-md-2 col-xs-5">Current Price:</strong><p class="col-md-4"> 267€</p>
                            </div>
                            <div class="row">
                                <strong class="col-md-2 col-xs-5">Starting Date:</strong><p class="col-md-4"> Tuesday, Mar 14, 2017 7:29:54</p>
                                <strong class="col-md-2 col-xs-5">Ending Date:</strong><p class="col-md-4"> Tuesday, Mar 17, 2017 7:29:54</p>
                            </div>
                            <div class="row">
                                <strong class="col-md-2 col-xs-5">Winning Bid:</strong><p class="col-md-4"> N/A</p>
                                <strong class="col-md-2 col-xs-5">Winner:</strong><p class="col-md-4"> N/A</p>
                            </div>
                            <div class="row">
                                <strong class="col-md-2 col-xs-5">Bidders:</strong><p class="col-md-4"> 69</p>
                                <strong class="col-md-2 col-xs-5">Watchers:</strong><p class="col-md-4"> 128</p>
                            </div>
                        </div>
                        <div id="seller" class="tab-pane fade">
                            <a><h3>CyberPowerPC</h3></a>
                            <p>CyberPowerPC is one of the nation-wide leading computer system manufacturers. As published in the Los Angeles Business Journal in 2003, we were the fastest growing private company in Los Angeles. With vision, commitment, and steadfast determination, we manufacture and distribute various customized high-end gaming machines, notebook systems and high performance workstations to meet the unique needs for gamers, businesses, government agencies, educational institutions and other end-users.</p>
                            <h4>Reliability</h4>
                            <p>CyberPowerPc was reviewed by 18 users, and has a average of 4.7/5 points.</p>
                        </div>
                    </div>
                </div>
            </div>

            <hr>

            <div class="row product-questions">
                <div class="col-md-12">
                    <h2>Product Q&A</h2>
                    <form class="newQuestion">
                        <div class="form-group">
                            <label>Your Question</label>
                            <textarea name="comment" class="form-control" rows="3"></textarea>
                        </div>
                        <button type="submit" class="btn btn-default">Send</button>
                    </form>

                    <section class="comment-list">
                        <article class="row">
                            <div class="col-md-1 col-sm-1 hidden-xs">
                                <figure class="thumbnail">
                                    <img class="img-responsive" src="http://www.keita-gaming.com/assets/profile/default-avatar-c5d8ec086224cb6fc4e395f4ba3018c2.jpg" />
                                </figure>
                            </div>
                            <div class="col-md-10 col-sm-10 col-xs-12">
                                <div class="panel panel-default arrow left">
                                    <div class="panel-body">
                                        <div class="media-heading">
                                            <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment">
                                                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                                            </button>
                                            <a href=""><strong>hant</strong></a> Feb 20th, 2017 at 9:37:41
                                        </div>
                                        <div class="panel-collapse collapse in" id="collapseComment">
                                            <div class="media-body">
                                                <p>
                                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                                                </p>
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

                        <article class="row">
                            <div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs">
                                <figure class="thumbnail">
                                    <img class="img-responsive" src="http://www.keita-gaming.com/assets/profile/default-avatar-c5d8ec086224cb6fc4e395f4ba3018c2.jpg" />
                                </figure>
                            </div>
                            <div class="col-md-9 col-sm-9 col-sm-offset-0 col-md-offset-0 col-xs-offset-1 col-xs-11">
                                <div class="panel panel-default arrow left">
                                    <div class="panel-body">
                                        <div class="media-heading">
                                            <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseReply">
                                                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
                                            </button>
                                            <a href=""><strong>hant</strong></a> Feb 20th, 2017 at 9:37:41
                                        </div>
                                        <div class="panel-collapse collapse in" id="collapseReply">
                                            <div class="media-body">
                                                <p>
                                                    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
                                                </p>
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
                    </section>
                </div>
            </div>

            <hr>

            <div class="row suggestions">
                <div class='col-md-12 col-centered'>
                    <h2>Similar Auctions</h2>
                    <div class="slider1">
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                        <div class="slide text-center">
              <span>
                <h4>Product Tittle</h4>
                <img src="http://placehold.it/256x256" alt="...">
                <button class="btn btn-info" style="margin: 0.5em;"> Watch Auction</button>
              </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="{$BASE_URL}lib/bxslider/jquery.bxslider.min.js"></script>
<script src="{$BASE_URL}javascript/auction.js"></script>

{include file='common/footer.tpl'}