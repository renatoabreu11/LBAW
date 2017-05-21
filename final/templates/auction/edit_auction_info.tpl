<form id="updateAuctionForm" action="{$BASE_URL}actions/auction/update_auction.php" method="post" enctype="multipart/form-data">
  <input type="hidden" name="token" value="{$TOKEN}">
  <input type="hidden" name="user_id" value="{$USER_ID}">
  <input type="hidden" name="auction_id" value="{$auction.id}">
  <div class="row setup-content" id="step-2">
    <div class="col-xs-12">
      <div class="col-md-12 well">
        <h3> Auction</h3>
        <div class="form-group">
          <label for="auction_type" class="control-label col-md-4"> Type<span> *</span> </label>
          <div class="col-md-8 col-xs-12 input-group">
            <select class="selectpicker input-md form-control" name="auction_type" id="auction_type" title="Define the auction type...">
              {foreach $auctionTypes as $key => $type}
                {if $type.unnest == $auction.type}
                  <option selected>{$type.unnest}</option>
                {else}
                  <option>{$type.unnest}</option>
                {/if}
              {/foreach}
            </select>
            <span class="input-group-addon">
            <a href="#" data-toggle="tooltip" title="Dutch - Begins with a high asking price which is lowered until some participant is willing to bid. Sealed Bid - All the bids are sealed.">
              <span class="sr-only">Auction type explanation</span>
              <i class="fa fa-question"></i>
            </a>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.auction_type}</strong>
        </div>
        <div class="form-group">
          <label for="base_price" class="control-label col-md-4"> Base Price<span> *</span> </label>
          <div class="col-md-8 col-xs-12 input-group">
            <input type="number" step="1" name="base_price" id="base_price" class="form-control" value="{$auction.start_bid}" min="1"  />
          </div>
          <strong class="field_error">{$FIELD_ERRORS.base_price}</strong>
        </div>
        <div class="form-group">
          <label for="quantity" class="control-label col-md-4"> Quantity of products<span> *</span> </label>
          <div class="col-md-8 input-group col-xs-12">
            <input class="input-md form-control" id="quantity" type="number" value="{$auction.quantity}" min="1" max="25" step="1" name="quantity">
          </div>
          <strong class="field_error">{$FIELD_ERRORS.quantity}</strong>
        </div>
        <div class="form-group">
          <label for="start_date" class="control-label col-md-4"> Starting Date<span> *</span> </label>
          <div class='col-md-8 col-xs-12 input-group date' id='startDatePicker'>
            <input type='text' class="form-control" name="start_date" id="start_date" value="{$auction.start_date}"/>
            <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.start_date}</strong>
        </div>
        <div class="form-group">
          <label for="end_date" class="control-label col-md-4"> Ending Date<span> *</span> </label>
          <div class='col-md-8 col-xs-12 input-group date' id='endDatePicker'>
            <input type='text' class="form-control" name="end_date" id="end_date" value="{$auction.end_date}"/>
            <span class="input-group-addon">
            <span class="glyphicon glyphicon-calendar"></span>
          </span>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.end_date}</strong>
        </div>
        <button class="btn btn-primary pull-right">Update auction</button>
      </div>
    </div>
  </div>
</form>