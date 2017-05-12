{include file = 'common/header.tpl'}

<div class="container watchList">
  <div class="row heading">
    <div class="col-md-12 index">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li class="active">
          Watchlist
        </li>
      </ul>
    </div>
    <h3 class="notification-page-title">Watchlist</h3>
    <p>As a bidder, you can track here your favorite auctions. You also can overview your own auctions.</p>
  </div>
  <div class="row" style="padding-left: 1.5em; padding-right: 1.5em;">
    <div class="col-xs-6" style="padding-top: 1.5em;">
      <ul class="auctionSort">
        <li id="popular" class="active"><a href="javascript:">Popular</a></li>
        <li id="newest"><a href="javascript:">Newest</a></li>
        <li id="ending"><a href="javascript:">Ending</a></li>
        <li id="priceLow"><a href="javascript:">Price (low)</a></li>
        <li id="priceHigh"><a href="javascript:">Price (high)</a></li>
        <li id="recentlyAdded"><a href="javascript:">Recently added</a></li>
      </ul>
    </div>
    <div class="controls col-xs-6" style="padding-top: 1.5em;">
      <label class="sr-only" for="watchlistFilter">Filter</label>
      <select class="selectpicker input-md textinput textInput form-control" id="watchlistFilter">
        <option selected>All auctions</option>
        <option>My auctions</option>
        <option>Closed auctions</option>
        <option>Open auctions</option>
      </select>
    </div>
  </div>
  <div id="auctionsThumbnails" class="row auctions" style="margin: auto;">
    {include file='auctions/list_watchlist.tpl'}
  </div>
  <div class="row text-center result">
    <ul id="pagination" class="pagination-sm" data-nr_pages="{$nrPages}"></ul>
  </div>
</div>

<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}lib/star-rating/jquery.rateyo.min.js"></script>
<script src="{$BASE_URL}lib/select/bootstrap-select.min.js"></script>
<script src="{$BASE_URL}lib/pagination/jquery.twbsPagination.min.js"></script>
<script src="{$BASE_URL}lib/tinysort/tinysort.js"></script>
<script src="{$BASE_URL}javascript/watchlist.js"></script>

{include file = 'common/footer.tpl'}