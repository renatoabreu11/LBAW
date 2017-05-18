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
							<label for="category" class="btn btn-info btn-block" data-toggle="collapse" data-target="#categories">Category</label>
							<div class="collapse" id="categories">
								<select class="form-control" id="category">
									<option value="All">All</option>
                  {foreach $categories as $category}
                    {if $category.name == $categorySearch}
											<option value="{$category.name}" selected>{$category.name}</option>
                    {else}
											<option value="{$category.name}">{$category.name}</option>
                    {/if}
                  {/foreach}
								</select>
								<br>
							</div>
							<div class="padding"></div>
							<button class="btn btn-info btn-block" data-toggle="collapse" data-target="#price">Price</button>
							<div class="collapse" id="price" style="padding-top: 0.5em; padding-bottom: 1em">
                <div id="slider-range" style="margin: 1em;"></div>
                <div class="text-center">
                  <label for="amount" class="sr-only">Price range</label>
                  <input type="text" id="amount" readonly style="text-align:center; border:0; color:#f6931f; font-weight:bold;">
                </div>
              </div>
							<div class="padding"></div>
							<button class="btn btn-info btn-block" data-toggle="collapse" data-target="#timeRemaining">Time remaining</button>
							<div class="collapse" id="timeRemaining">
								<label for="fromTimeRem">From:</label>
								<select class="form-control" id="fromTimeRem">
									<option value="0" selected>now</option>
									<option value="1800">30 minutes</option>
									<option value="3600">1 hour</option>
									<option value="86400">1 day</option>
									<option value="604800">1 week</option>
								</select>
								<label for="toTimeRem">To:</label>
								<select class="form-control" id="toTimeRem">
									<option value="1800">30 minutes</option>
									<option value="3600">1 hour</option>
									<option value="86400">1 day</option>
									<option value="604800" selected>1 week</option>
								</select>
							</div>
						</div>
						<div class="col-md-9 col-xs-12 col-sm-12">
							<h2> Auctions</h2>
							<hr>
							<div class="input-group">
						<span class="input-group-btn">
						<button class="btn btn-secondary" id="searchBtn">Search</button>
						</span>
								<input type="text" class="form-control" placeholder="Select your filters and then hit search..." id="inputSearch">
							</div>
							<h6 style="color: darkgray;">Showing all results matching "{$textSearch}"</h6>
							<div class="row">
								<div class="col-sm-8 col-xs-8">
									<ul class="auctionSort">
										<li id="popular" class="active"><a href="javascript:">Popular</a></li>
										<li id="newest"><a href="javascript:">Newest</a></li>
										<li id="ending"><a href="javascript:">Ending</a></li>
										<li id="priceLow"><a href="javascript:">Price (low)</a></li>
										<li id="priceHigh"><a href="javascript:">Price (high)</a></li>
									</ul>
								</div>
								<div class="col-md-4 text-center pull-right col-xs-4" id="listType">
									<div class="btn-group">
										<button id="list_btn" class="btn btn-default btn-responsive active" data-target="#auctionsList"><i class="fa fa-list"></i></button>
										<button id="list_thumbnail_btn" class="btn btn-default btn-responsive" data-target="#auctionsThumbnails"><i class="fa fa-th"></i></button>
									</div>
								</div>
							</div>
							<div class="row" id="auctions">
                {include file='auctions/list.tpl'}
							</div>
							<div class="row collapse" id="auctionsThumbnails">
                {include file='auctions/list_thumbnail.tpl'}
							</div>
							<div class="row text-center">
								<ul id="pagination" class="pagination-sm" data-nr_pages="{$nrPages}" data-curr_page="1"></ul>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

<script src="{$BASE_URL}lib/pagination/jquery.twbsPagination.min.js"></script>
<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
<script src="{$BASE_URL}lib/tinysort/tinysort.js"></script>
<script src="{$BASE_URL}lib/jqueryui/jquery-ui.min.js"></script>
<script src="{$BASE_URL}javascript/auctions.js"></script>

{include file='common/footer.tpl'}
