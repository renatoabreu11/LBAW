<div class="row setup-content" id="step-2">
    <div class="col-xs-12">
        <div class="col-md-12 well">
            <h3> Auction</h3>
            <div class="form-group">
                <label class="control-label col-md-4"> Type<span>*</span> </label>
                <div class="col-md-8 col-xs-12 input-group">
                    <select class="selectpicker input-md form-control" name="auction_type" id="auction_type" title="Define the auction type...">
                        <option>Dutch Auction</option>
                        <option>Sealed-bid Auction</option>
                        <option>Default</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="basePrice" class="control-label col-md-4"> Base Price<span>*</span> </label>
                <div class="col-md-8 col-xs-12 input-group">
                    <input type="number" step="1" name="base_price" id="base_price" class="form-control" value="1" min="1"  />
                </div>
            </div>
            <div class="form-group">
                <label for="start_date" class="control-label col-md-4"> Starting Date<span>*</span> </label>
                <div class="col-md-8 col-xs-12 input-group">
                    <input type="datetime-local" class="form-control" name="start_date" id="start_date"/>
                </div>
            </div>
            <div class="form-group">
                <label for="end_date" class="control-label col-md-4"> Ending Date<span>*</span> </label>
                <div class="input-group col-md-8 col-xs-12">
                    <input type="datetime-local" class="form-control" name="end_date" id="end_date"/>
                </div>
            </div>
            <button id="activate-step-3" class="btn btn-primary pull-right">Next Step</button>
        </div>
    </div>
</div>