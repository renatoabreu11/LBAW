<div class="row setup-content" id="step-1">
    <div class="col-xs-12">
        <div class="col-md-12 well">
            <h3> Product Specification</h3>
            <div class="form-group">
                <label for="productName" class="control-label col-md-4"> Name<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <input class="input-md form-control" id="productName" name="name" placeholder="Define the product name" type="text"/>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-4 col-xs-12"> Information<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <label class="radio-inline active"><input type="radio" name="optradio" checked="" value="personalized">Personalized</label>
                    <label class="radio-inline"><input type="radio" name="optradio" value="api">API information</label>
                    <button class="btn btn-primary apiProduct hidden">Choose a product from Amazon</button>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-4"> Category<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <select class="input-md form-control selectpicker" multiple data-max-options="2" data-live-search="true" title="Define the product category...">
                        {foreach $categories as $key => $category}
                           <option>{$category.unnest}</option>
                        {/foreach}
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="quantity" class="control-label col-md-4"> Quantity<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <input class="input-md form-control" id="quantity" type="number" value="1" min="1" max="25" step="1" name="quantity">
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-4"> Details<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <textarea maxlength="1000" required="required" class="form-control" placeholder="Tell us about your product" ></textarea>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-md-4"> Condition<span>*</span> </label>
                <div class="col-md-8 input-group col-xs-12">
                    <textarea maxlength="1000" required="required" class="form-control" placeholder="Tell us about the product condition" ></textarea>
                </div>
            </div>

            <label> Gallery<span>*</span> </label>
            <input id="input-24" name="input24[]" type="file" multiple class="file-loading">

            <button id="activate-step-2" class="btn btn-primary pull-right">Next Step</button>
        </div>
    </div>
</div>