<div class="adminOption">
    <div class="categories col-md-12">
        <h4><i class="fa fa-list-ul" aria-hidden="true"></i> Categories</h4>
        <ul class="list-group col-md-6" style="padding-top: 0.5em;">
            {foreach $categories as $categoryObject}
                {foreach $categoryObject as $name}
                <li class="list-group-item">{$name}</li>
                {/foreach}
            {/foreach}
        </ul>
    </div>

    <div class="addCategory col-md-12">
        <h4><i class="glyphicon glyphicon-dashboard"></i> Add category</h4>

        <form class="form-horizontal" style="padding-top: 1em;">
            <div class="form-group row">
                <div class="col-md-6">
                    <input name="title" type="text" placeholder="Enter a new category" class="form-control input-md"
                           required>
                </div>
            </div>
            <div class="form-group">
                <div class="col-md-6 text-center">
                    <button name="saveBtn" class="btn btn-primary">Add</button>
                </div>
            </div>
        </form>
    </div>
</div>