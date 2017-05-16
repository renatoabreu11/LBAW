<div class="row setup-content" id="step-1">
  <div class="col-xs-12">
    <div class="col-md-12 well">
      <h3> Product Specification</h3>
      <div class="form-group">
        <label for="product_name" class="control-label col-md-4"> Name<span> *</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <input class="input-md form-control" id="product_name" required maxlength="64" name="product_name" placeholder="Define the product name" type="text" value="{$FORM_VALUES.product_name}"/>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.product_name}</strong>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4 col-xs-12">
          Information
          <span>*</span>
        </label>
        <div class="col-md-8 input-group col-xs-12">
          <label class="radio-inline active">
            <input type="radio" name="optradio" checked="" value="personalized">
            <a href="#" data-toggle="tooltip" title="Define the product information.">Personalized</a>
          </label>
          <label class="radio-inline">
            <input type="radio" name="optradio" value="api">
            <a href="#" data-toggle="tooltip" title="Select a product from the amazon store!">API information</a>
          </label>
        </div>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4"> Category<span> *</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <select class="input-md form-control selectpicker" id="category" name="category[]" multiple data-max-options="2" data-live-search="true" title="Define the product category...">
            {foreach $categories as $category}
              {if $category.name == $FORM_VALUES.category[0] || $category.name == $FORM_VALUES.category[1]}
                <option selected>{$category.name}</option>
              {else}
                <option>{$category.name}</option>
              {/if}
            {/foreach}
          </select>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.category}</strong>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4"> Description<span> *</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <textarea maxlength="512" required class="form-control" id="description" name="description" placeholder="Tell us about your product" >{$FORM_VALUES.description}</textarea>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.description}</strong>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4"> Condition<span> *</span> </label>
        <div class="col-md-8 input-group col-xs-12">
          <textarea maxlength="512" required class="form-control" id="condition" name="condition" placeholder="Tell us about the product condition" >{$FORM_VALUES.condition}</textarea>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.condition}</strong>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4"> Characteristics</label>
        <div class="col-md-8 input-group col-xs-12" style="padding-bottom: 0.5em;">
          <input class="input-md form-control" name="newCharacteristic" placeholder="Add a new characteristic" type="text"/>
          <span class="input-group-addon addon-icon addCharacteristic">
    				<span class="glyphicon glyphicon-plus"></span>
    			</span>
        </div>
        <div class="col-md-8 input-group col-xs-12 col-md-offset-4">
          <select class="input-md form-control selectpicker" id="characteristics" multiple data-max-options="10" data-live-search="true" name="characteristics[]" title="Choose here the product characteristics">
            {foreach $FORM_VALUES.characteristics as $characteristic}
              <option>{$characteristic}</option>
            {/foreach}
          </select>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.characteristics}</strong>
      </div>
      <button id="activate-step-2" class="btn btn-primary pull-right">Next Step</button>
    </div>
  </div>
</div>