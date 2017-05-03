{include file = 'common/header.tpl'}

<div class="container watchList">
  <div class="row heading">
    <div class="col-md-12 index">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li>
          <a href="#">Auctions</a> <span class="divider"></span>
        </li>
        <li class="active">
          Watchlist
        </li>
      </ul>
    </div>
    <h3>Watchlist</h3>
  </div>

  <div class="col-sm-12" style="padding-top: 1.5em;">
    <ul class="auctionSort">
      <li class="active"><a href="#">Popular</a></li>
      <li><a href="#">Newest</a></li>
      <li><a href="#">Ending</a></li>
      <li><a href="#">Price (low)</a></li>
      <li><a href="#">Price (high)</a></li>
      <li><a href="#">Recently added</a></li>
    </ul>
  </div>

  <div class="row" style="padding-left: 1.5em; padding-right: 1.5em;">
    <div class="col-sm-6 col-xs-6">
      <form>
        <div class="input-group">
          <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
          <input type="text" class="form-control" name="userWatchList" placeholder="Filter auctions by seller...">
        </div>
      </form>
    </div>

    <div class="controls col-sm-6 col-xs-6">
      <select class="selectpicker input-md textinput textInput form-control" title="Type of auctions">
        <option>All auctions</option>
        <option>My auctions</option>
        <option>Closed auctions</option>
        <option>Open auctions</option>
      </select>
    </div>
  </div>

  {if $nrPages > 1}
    <div class="row text-center">
      <ul class="pagination">
        {if $currPage == 1}
          <li class="disabled"><a>«</a></li>
        {else}
          <li ><a href="{$BASE_URL}pages/auctions/watchlist.php?page={$currPage - 1}">«</a></li>
        {/if}
        {for $i=1; $i <= $nrPages; $i++}
          {if $currPage == $i}
            <li class="active"><a>{$i} <span class="sr-only">(current)</span></a></li>
          {else}
            <li ><a href="{$BASE_URL}pages/auctions/watchlist.php?page={$i}">{$i} </a></li>
          {/if}
        {/for}
        {if $currPage == $nrPages}
          <li class="disabled"><a>»</a></li>
        {else}
          <li ><a href="{$BASE_URL}pages/auctions/watchlist.php?page={$currPage + 1}">»</a></li>
        {/if}
      </ul>
    </div>
  {/if}
</div>

<script src="{$BASE_URL}lib/countdown/jquery.countdown.min.js"></script>
<script src="{$BASE_URL}javascript/auctions.js"></script>

{include file = 'common/footer.tpl'}