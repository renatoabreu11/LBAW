<div class="adminOption">
  <div class="categories col-md-12">
    <h4><i class="fa fa-th-list" aria-hidden="true"></i> Categories</h4>
    <p>Here, you can manage the product categories. Be aware that removing a category that is being used by a product, removes the respective association.</p>
    <ul class="list-group col-md-12" style="padding-top: 0.5em;">
      {foreach $categories as $category}
        <li class="list-group-item col-md-3">
          {$category.name}
          <a class="removeCategoryPopup id-{$category.id}" href="#removeCategoryConfirmation">
            <span class="sr-only">Remove category</span>
            <i class="fa fa-times pull-right" aria-hidden="true"></i>
          </a>
        </li>
      {/foreach}
    </ul>
  </div>
  <div id="removeCategoryConfirmation" class="white-popup mfp-hide">
    <h4>Are you sure that you want to delete this category?</h4>
    <p>You will not be able to undo this action!</p>
    <div class="text-center">
      <button class="btn btn-info removeCategory">Yes, I'm sure</button>
      <button class="btn btn-info closePopup">No, go back</button>
    </div>
  </div>
  <div class="addCategory col-md-12">
    <h4><i class="fa fa-plus-circle"></i> Add category</h4>
    <form id="newCategory" class="form-horizontal" style="padding-top: 1em;" action="{$BASE_URL}api/admin/add_category.php" method="post" enctype="multipart/form-data">
      <div class="form-group row">
        <label class="sr-only" for="title">New category</label>
        <div class="col-md-6">
          <input name="title" type="text" maxlength="64" placeholder="Enter a new category" class="form-control input-md"
                 required id="title">
          <strong class="field_error"></strong>
        </div>
      </div>
      <div class="form-group">
        <div class="col-md-6 text-center">
          <button name="saveBtn" class="btn btn-info">Add new category</button>
        </div>
      </div>
    </form>
  </div>
</div>