{include file='common/header.tpl'}

<div class="container newAuctionH">
  <div class="row heading">
    <div class="col-md-12 index">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li>
          <a href="{$BASE_URL}pages/auction/auction.php?id={$auction.id}">Auction</a> <span class="divider"></span>
        </li>
        <li class="active">
          Edit Auction
        </li>
      </ul>
    </div>
    <h3>
      Edit auction
    </h3>
    <p>You only can edit the auction while it has not yet started.</p>
  </div>
  <div class="row form-group stepWizard">
    <div class="col-xs-12">
      <ul class="nav nav-pills nav-justified thumbnail setup-panel">
        <li class="active">
          <a href="#step-1">
            <h4 class="list-group-item-heading"><i class="fa fa-shopping-bag" aria-hidden="true"></i>
              Product</h4>
            <p class="list-group-item-text">Item to be auctioned</p>
          </a>
        </li>
        <li>
          <a href="#step-2">
            <h4 class="list-group-item-heading"><i class="fa fa-legal" aria-hidden="true"></i>
              Auction</h4>
            <p class="list-group-item-text">Info about the auction</p>
          </a>
        </li>
        <li>
          <a href="#step-3">
            <h4 class="list-group-item-heading"><i class="fa fa-cogs" aria-hidden="true"></i> Settings</h4>
            <p class="list-group-item-text">Notifications and extra details</p>
          </a>
        </li>
      </ul>
    </div>
  </div>
  {include file='auction/edit_product_info.tpl'}
  {include file='auction/edit_auction_info.tpl'}
  {include file='auction/edit_settings.tpl'}
</div>

<script src="{$BASE_URL}lib/datetimepicker/moment.js"></script>
<script src="{$BASE_URL}lib/datetimepicker/pt.js"></script>
<script src="{$BASE_URL}lib/datetimepicker/bootstrap-datetimepicker.min.js"></script>
<script src="{$BASE_URL}lib/select/bootstrap-select.js"></script>
<script src="{$BASE_URL}javascript/edit_auction.min.js"></script>

{include file='common/footer.tpl'}