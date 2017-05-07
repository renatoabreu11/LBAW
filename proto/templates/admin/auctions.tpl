<div class="adminOption">
  <h4><i class="fa fa-users" aria-hidden="true"></i> Auctions list</h4>
  <div class="table-responsive">
    <table id="auctionsTable" class="table row-border">
      <thead>
      <tr>
        <th>#</th>
        <th>Product</th>
        <th>Owner</th>
        <th>Type</th>
        <th>Start Date</th>
        <th>End Date</th>
      </tr>
      </thead>
      <tbody>
      {foreach $auctions as $auction}
        <tr>
          <td>{$auction.id}</td>
          <td>{$auction.product}</td>
          <td><a href="{$BASE_URL}pages/user/user.php?id={$auction.seller_id}">{$auction.seller}</a></td>
          <td>{$auction.type}</td>
          <td>{$auction.start_date}</td>
          <td>{$auction.end_date}</td>
        </tr>
      {/foreach}
      </tbody>
    </table>
  </div>

  <div class="text-center userOptions">
    <a class="btn btn-info removePopup" href="#removeAuctionConfirmation">Remove selected auction</a>
    <a class="btn btn-info exportAuctions">Export auctions</a>
  </div>

  <div id="removeAuctionConfirmation" class="white-popup mfp-hide">
    <h4>Are you sure that you want to delete this auction?</h4>
    <p>You will not be able to undo this action!</p>
    <div class="text-center">
      <button class="btn btn-info removeAuction">Yes, I'm sure</button>
      <button class="btn btn-info closePopup">No, go back</button>
    </div>
  </div>
</div>