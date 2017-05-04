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
								<select class="form-control" id="category">
									<option value="All" selected="selected">All</option>
                  						{foreach $categories as $category}
										<option value="{$category.name}">{$category.name}</option>
                  						{/foreach}
								</select>
								<br>
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
									<option value="3600">1 hour</option>
									<option value="86400">1 day</option>
									<option value="604800" selected="selected">1 week</option>
								</select>
							</div>
						</div>

						<div class="col-md-9 col-xs-12 col-sm-9">
							<h2> Auctions</h2>
							<hr>
							<div class="input-group">
						<span class="input-group-btn">
						<button class="btn btn-secondary" type="button" id="searchBtn">Search</button>
						</span>
								<input type="text" class="form-control" placeholder="Search for auction..." id="inputSearch">
							</div>
							<h6 style="color: darkgray;">Showing all results matching "{$textSearch}"</h6>

							<div class="row">
								<div class="col-sm-8 col-xs-12">
									<ul class="auctionSort">
										<li id="popular" class="active"><a href="javascript:;">Popular</a></li>
										<li id="newest"><a href="javascript:;">Newest</a></li>
										<li id="ending"><a href="javascript:;">Ending</a></li>
										<li id="priceLow"><a href="javascript:;">Price (low)</a></li>
										<li id="priceHigh"><a href="javascript:;">Price (high)</a></li>
									</ul>
								</div>

								<div class="col-md-4 text-center pull-right col-xs-8" id="listType">
									<div class="btn-group">
										<button id="list_btn" type="button" class="btn btn-default btn-responsive active" data-target="#auctionsList"><i class="fa fa-list"></i></button>
										<button id="list_thumbnail_btn" type="button" class="btn btn-default btn-responsive" data-target="#auctionsThumbnails"><i class="fa fa-th"></i></button>
									</div>
								</div>
							</div>

							<div class="row table-responsive" id="auctions">
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
<script src="{$BASE_URL}javascript/auctions.js"></script>

{include file='common/footer.tpl'}