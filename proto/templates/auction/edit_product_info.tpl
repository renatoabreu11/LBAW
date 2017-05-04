<form id="updateProductForm" action="{$BASE_URL}actions/auction/update_product.php" method="post" enctype="multipart/form-data">
  <input type="hidden" name="token" value="{$TOKEN}">
  <input type="hidden" name="user_id" value="{$USER_ID}">
  <input type="hidden" name="auction_id" value="{$auction.id}">
  <div class="row setup-content" id="step-1">
    <div class="col-xs-12">
      <div class="col-md-12 well">
        <h3> Product Specification</h3>
        <div class="form-group">
          <label for="product_name" class="control-label col-md-4"> Name<span>*</span> </label>
          <div class="col-md-8 input-group col-xs-12">
            <input class="input-md form-control" id="product_name" name="product_name" placeholder="Define the product name" type="text" value="{$product.name}"/>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.product_name}</strong>
        </div>

        <div class="form-group">
          <label class="control-label col-md-4"> Category<span>*</span> </label>
          <div class="col-md-8 input-group col-xs-12">
            <select class="input-md form-control selectpicker" id="category" name="category[]" multiple data-max-options="2" data-live-search="true" title="Define the product category...">
              {foreach $categories as $category}
                {if $category.name == $productTypes[0].name || $category.name == $productTypes[1].name}
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
          <label class="control-label col-md-4"> Description<span>*</span> </label>
          <div class="col-md-8 input-group col-xs-12">
            <textarea maxlength="512" class="form-control" id="description" name="description" placeholder="Tell us about your product" >{$product.description}</textarea>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.description}</strong>
        </div>

        <div class="form-group">
          <label class="control-label col-md-4"> Condition<span>*</span> </label>
          <div class="col-md-8 input-group col-xs-12">
            <textarea maxlength="512" class="form-control" id="condition" name="condition" placeholder="Tell us about the product condition" >{$product.condition}</textarea>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.condition}</strong>
        </div>

        <button type="submit" class="btn btn-primary pull-right">Update product</button>
      </div>
    </div>
  </div>
</form>