{include file='common/header.tpl'}

<div class="container newAuctionH">

    <div class="row heading">
        <div class="col-md-12 index">
            <ul class="breadcrumb">
                <li>
                    <a href="#">Home</a> <span class="divider"></span>
                </li>
                <li class="active">
                    <a href="#">Auctions</a> <span class="divider"></span>
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

    <div class="row setup-content" id="step-1">
        <div class="col-xs-12">
            <div class="col-md-12 well">
                <h3> Product Specification</h3>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Name<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8 ">
                        <input class="input-md textInput form-control" id="productName" maxlength="50" name="name" placeholder="Define your product name" type="text" />
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Information<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <label class="radio-inline"><input type="radio" name="optradio">Personalized</label>
                        <label class="radio-inline"><input type="radio" name="optradio">API information</label>
                    </div>
                    <div class="col-md-12 text-center retrieveInfoAPI">
                        <button class="btn btn-primary" style="margin-bottom: 1em;">Choose a product from Shopify</button>
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Category<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <select class="selectpicker input-md textinput textInput form-control" multiple data-max-options="2" title="Define the product category...">
                            <option>Books</option>
                            <option>Movies, Music & TV</option>
                            <option>Electronics & Computers</option>
                            <option>Clothes</option>
                            <option>Sports & Outdoors</option>
                        </select>
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Quantity<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <input class="input-md textInput form-control" type="number" min="1" max="25" step="1" name="quantity">
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Details<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <textarea maxlength="1000" required="required" class="form-control" placeholder="Tell us about your product" ></textarea>
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Condition<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <textarea maxlength="1000" required="required" class="form-control" placeholder="Tell us about the product condition" ></textarea>
                    </div>
                </div>

                <div class="form-group required">
                    <label class="control-label col-md-4 requiredField"> Gallery<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <input type="file" class="form-control"  placeholder="Choose your images"/>
                    </div>
                </div>

                <button id="activate-step-2" class="btn btn-primary pull-right">Next Step</button>
            </div>
        </div>
    </div>
    <div class="row setup-content" id="step-2">
        <div class="col-xs-12">
            <div class="col-md-12 well">
                <h3> Auction</h3>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Type<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <select class="selectpicker input-md textinput textInput form-control" title="Define the auction type...">
                            <option>Dutch Auction</option>
                            <option>First-price Sealed-bid Auction</option>
                            <option>Default</option>
                        </select>
                    </div>
                </div>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Base Price<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <input type="number" step="0.01" required="required" class="form-control" value="0.00" min="0.00"  />
                    </div>
                </div>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Starting Date<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <input type="datetime-local" class="form-control" name="auction_start" id="auction_start"/>
                    </div>
                </div>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Ending Date<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <input type="datetime-local" class="form-control" name="auction_end" id="auction_end"/>
                    </div>
                </div>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Fixed Price<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <select class="selectpicker input-md textinput textInput form-control" title="Define if the auction has a fixed price to buy the item...">
                            <option>Yes</option>
                            <option>No</option>
                        </select>
                    </div>
                </div>
                <button id="activate-step-3" class="btn btn-primary pull-right">Next Step</button>
            </div>
        </div>
    </div>
    <div class="row setup-content" id="step-3">
        <div class="col-xs-12">
            <div class="col-md-12 well">
                <h3> Settings</h3>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Q&A section<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <select class="selectpicker input-md textinput textInput form-control" title="Do you want to answer questions about the product?">
                            <option>Yes</option>
                            <option>No</option>
                        </select>
                    </div>
                </div>
                <div class="form-group required">
                    <label for="productName" class="control-label col-md-4 requiredField"> Notifications<span class="asteriskField">*</span> </label>
                    <div class="controls col-md-8">
                        <select class="selectpicker input-md textinput textInput form-control" multiple data-actions-box="true" title="Choose the type of notifications that you will receive...">
                            <option>Auction Started</option>
                            <option>Auction Ended</option>
                            <option>Bids on auction</option>
                            <option>New questions on Q&A</option>
                            <option>None</option>
                        </select>
                    </div>
                </div>
                <button class="btn btn-primary pull-right" type="submit">Create Auction</button>
            </div>
        </div>
    </div>
</div>

<script src="{$BASE_URL}javascript/create_auction.js"></script>

{include file='common/footer.tpl'}