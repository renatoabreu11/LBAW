{include file='common/header.tpl'}

<div class="container">
  	<div class="row">

	    <div class="col-md-12">
	      <div class="grid search">
	        <div class="grid-body">
	          <div class="row">
	            <div class="col-md-3 hidden-xs">
	              <h2 class="grid-title"> Filters</h2>
	              <hr>

	              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#categories">Category</button>

	              <div class="collapse" id="categories">
	              	{foreach $categories as $category}
					<div class="checkbox">
						<label><input type="checkbox" class="category">{$category.unnest}</label>
					</div>
	            	{/foreach}
	              </div>

	              <div class="padding"></div>

	              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#price">Price</button>
	              <div class="collapse" id="price">
	              	<b>From:</b>
				      <select class="form-control" id="fromPrice">
				        <option value="0" selected="selected">0 €</option>
				        <option value="10">10 €</option>
				        <option value="50">50 €</option>
				        <option value="100">100 €</option>
				        <option value="250">250 €</option>
				        <option value="500">500 €</option>
				        <option value="1000">1000 €</option>
				      </select>
				      <b>To:</b>
				      <select class="form-control" id="toPrice">
				        <option value="0">0 €</option>
				        <option value="10">10 €</option>
				        <option value="50">50 €</option>
				        <option value="100">100 €</option>
				        <option value="250">250 €</option>
				        <option value="500">500 €</option>
				        <option value="1000" selected="selected">1000 €</option>
				      </select>
				      <br>
	              </div>

	              <div class="padding"></div>

	              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#type">Type</button>
	              <div class="collapse" id="type">
	              	Not defined!!!
	              </div>

	              <div class="padding"></div>

	              <button type="button" class="btn btn-info btn-block" data-toggle="collapse" data-target="#timeRemaining">Time remaining</button>
	              <div class="collapse" id="timeRemaining">
	                <b>From</b>
					<select class="form-control" id="fromTimeRem">
						<option value="0" selected="selected">now</option>
						<option value="1800">30 minutes</option>
				        <option value="3600">1 hour</option>
				        <option value="86400">1 day</option>
				        <option value="604800">1 week</option>
				    </select>
				    <b>To</b>
					<select class="form-control" id="toTimeRem">
						<option value="1800">30 minutes</option>
				        <option value="3600" selected="selected">1 hour</option>
				        <option value="86400">1 day</option>
				        <option value="604800">1 week</option>
				    </select>
	            </div>
	        </div>

	         <div class="col-md-9 col-xs-12 col-sm-9">
	              <h2> Auctions</h2>
	              <hr>
					<div class="input-group">
						<span class="input-group-btn">
						<button class="btn btn-secondary" type="button">Search</button>
						</span>
						<input type="text" class="form-control" placeholder="Search for auction...">
				    </div>
	              <h6 style="color: darkgray;">Showing all results matching "{$search}"</h6>

	              <div class="row">
	                <div class="col-sm-8 col-xs-12">
	                    <ul class="auctionSort">
	                      <li class="active"><a href="#">Popular</a></li>
	                      <li><a href="#">Newest</a></li>
	                      <li><a href="#">Ending</a></li>
	                      <li><a href="#">Price (low)</a></li>
	                      <li><a href="#">Price (high)</a></li>
	                    </ul>
	                </div>

	                <div class="col-md-4 text-center pull-right col-xs-8" id="listType">
	                  <div class="btn-group">
	                    <button type="button" class="btn btn-default btn-responsive active" data-target="#auctionsList"><i class="fa fa-list"></i></button>
	                    <button type="button" class="btn btn-default btn-responsive" data-target="#auctionsThumbnails"><i class="fa fa-th"></i></button>
	                  </div>
	                </div>
	              </div>

	               <div class="table-responsive" id="auctions">
	                <table class="table table-hover collapse in" id="auctionsList">
	                  <tbody>
	                   {foreach $auctions as $auction}
		                <tr>
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
	              </div>

		          <div class="collapse" id="auctionsThumbnails">
		          	{foreach $auctions as $auction}
		          	<div class="col-md-3 col-sm-6 col-xs-6">
		              <span class="thumbnail text-center">
		                <h4 style="height: 50px;">{$auction.product_name}</h4>
		                <img src="https://www.thurrott.com/wp-content/uploads/2015/10/surface-book-hero.jpg" alt="...">
		                <small>Current bid: {$auction.curr_bid} €</small>
		                <div class="countdown" style="height: 50px;">
		                    <span class="clock"><p hidden>{$auction.end_date}</p></span>
		                </div>
		                <div class="watchAuction">
		                  <button class="btn btn-info btn-sm"><a href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}" style="color: white;">Watch Auction</a></button>
		                </div>
		                <div class="seller" style="height: 75px;">
		                  <p>Product auctioned by <a href="{$BASE_URL}pages/user/user.php?id={$auction.user_id}">{$auction.username}</a></p>
		                  <span>
		                     {if ($auction.user_rating != null) }
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
		                </div>
		              </span>
		            </div>
		            {/foreach}
		           </div>
		           <div class="text-center">
	                <ul class="pagination">
	                  <li class="disabled"><a href="#">«</a></li>
	                  <li class="active"><a href="#">1</a></li>
	                  <li><a href="#">2</a></li>
	                  <li><a href="#">3</a></li>
	                  <li><a href="#">4</a></li>
	                  <li><a href="#">5</a></li>
	                  <li><a href="#">»</a></li>
	                </ul>
	              </div>
	       		</div>
	            </div>
	        </div>
	    </div>
	</div>
</div>
</div>


<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}javascript/auctions.js"></script>

{include file='common/footer.tpl'}