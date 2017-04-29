<div class="row setup-content" id="step-1">
  <div class="col-xs-12">
    <div class="col-md-12 well">
      <h3> Product Specification</h3>
      <div class="form-group">
        <label for="productName" class="control-label col-md-4"> Name<span>*</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <input class="input-md form-control" id="product_name" name="product_name" placeholder="Define the product name" type="text" value="{$FORM_VALUES.product_name}"/>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.product_name}</strong>
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
          <select class="input-md form-control selectpicker" id="category" name="category[]" multiple data-max-options="2" data-live-search="true" title="Define the product category...">
            {foreach $categories as $key => $category}
              <option>{$category.unnest}</option>
            {/foreach}
          </select>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.category}</strong>
      </div>

      <div class="form-group">
        <label for="quantity" class="control-label col-md-4"> Quantity<span>*</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <input class="input-md form-control" id="quantity" type="number" value="{$FORM_VALUES.quantity}" min="1" max="25" step="1" name="quantity">
        </div>
        <strong class="field_error">{$FIELD_ERRORS.quantity}</strong>
      </div>

      <div class="form-group">
        <label class="control-label col-md-4"> Description<span>*</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <textarea maxlength="512" class="form-control" id="description" name="description" placeholder="Tell us about your product" >{$FORM_VALUES.description}</textarea>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.description}</strong>
      </div>

      <div class="form-group">
        <label class="control-label col-md-4"> Condition<span>*</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <textarea maxlength="512" class="form-control" id="condition" name="condition" placeholder="Tell us about the product condition" >{$FORM_VALUES.condition}</textarea>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.condition}</strong>
      </div>

      <button id="activate-step-2" class="btn btn-primary pull-right">Next Step</button>
    </div>
  </div>
</div>