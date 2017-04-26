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
                    New Auction
                </li>
            </ul>
        </div>
        <h3>
            Create a new auction
        </h3>
        <p>An auction is a process of buying and selling goods or services by offering them up for bid, taking bids, and then selling the item to the highest bidder.</p>
    </div>
    <div class="row form-group stepWizard">
        <div class="col-xs-12">
            <ul class="nav nav-pills nav-justified thumbnail setup-panel">
                <li class="active"><a href="#step-1">
                        <h4 class="list-group-item-heading"><i class="fa fa-shopping-bag" aria-hidden="true"></i>
                            Product</h4>
                        <p class="list-group-item-text">Item to be auctioned</p>
                    </a></li>
                <li class="disabled"><a href="#step-2">
                        <h4 class="list-group-item-heading"><i class="fa fa-legal" aria-hidden="true"></i>
                            Auction</h4>
                        <p class="list-group-item-text">Info about the auction</p>
                    </a></li>
                <li class="disabled"><a href="#step-3">
                        <h4 class="list-group-item-heading"><i class="fa fa-cogs" aria-hidden="true"></i> Settings</h4>
                        <p class="list-group-item-text">Notifications and extra details</p>
                    </a></li>
            </ul>
        </div>
    </div>
    <form id="createAuctionForm" action="{$BASE_URL}actions/auction/create_auction.php" method="post" enctype="multipart/form-data">
        <input type="hidden" name="token" value="{$TOKEN}">
        {include file='auction/product_info.tpl'}
        {include file='auction/auction_info.tpl'}
        {include file='auction/extra_info.tpl'}
        <div class="form-group text-center" id="createAuction-btn">
            <button class="btn btn-primary pull-right" style="margin-right: 2em;" type="submit">Create Auction</button>
        </div>
    </form>
</div>

<script src="{$BASE_URL}lib/fileinput/fileinput.js"></script>
<script src="{$BASE_URL}lib/select/bootstrap-select.js"></script>
<script src="{$BASE_URL}javascript/create_auction.js"></script>

{include file='common/footer.tpl'}