<div class="adminOption">
  <div class="categories col-md-12">
    <h4><i class="fa fa-list-ul" aria-hidden="true"></i> Categories</h4>

    <ul class="list-group col-md-12" style="padding-top: 0.5em;">
      {foreach $categories as $category}
        <li class="list-group-item col-md-3">{$category.name}</li>
      {/foreach}
    </ul>
  </div>

  <div class="addCategory col-md-12">
    <h4><i class="glyphicon glyphicon-dashboard"></i> Add category</h4>

    <form id="newCategory" class="form-horizontal" style="padding-top: 1em;" action="{$BASE_URL}api/admin/add_category.php" method="post" enctype="multipart/form-data">
      <div class="form-group row">
        <div class="col-md-6">
          <input name="title" type="text" maxlength="32" placeholder="Enter a new category" class="form-control input-md"
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