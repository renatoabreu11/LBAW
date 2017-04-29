{include file='common/header.tpl'}

<div class="container newAuctionH">

  <div class="row heading">
    <div class="col-md-12 index">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Auctions</a> <span class="divider"></span>
        </li>
        <li class="active">
          Auction Gallery
        </li>
      </ul>
    </div>
    <h3>
      Auction images
    </h3>
    <p>Choose here the images to show to potential bidders.</p>

    <input type="hidden" name="token" id="token" value="{$token}">
    <input type="hidden" name="product_id" id="product_id" value="{$product.product_id}">
    <div class="image_upload">
      <input id="input-24" name="input24[]" type="file" multiple class="file-loading">
    </div>
  </div>
</div>


<script src="{$BASE_URL}lib/fileinput/fileinput.js"></script>
<script src="{$BASE_URL}javascript/create_auction.js"></script>

{include file='common/footer.tpl'}